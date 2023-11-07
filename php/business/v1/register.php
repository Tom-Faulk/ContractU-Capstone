<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $this->validate();

        $this->verifyGoogleCredentials();
        
        $this->process();
    }

    function validate() {
        if (
            empty($_POST['google_credentials_access_token']) ||
            empty($_POST['google_credentials_expires_in']) ||
            empty($_POST['google_credentials_id_token']) ||
            empty($_POST['email']) ||
            empty($_POST['company_name']) ||
            empty($_POST['company_url']) ||
            empty($_POST['company_description']) ||
            empty($_POST['phone_number']) ||
            empty($_POST['address']) ||
            empty($_POST['zip_code']) ||
            empty($_FILES['license']) ||
            $_FILES['license']['type'] != 'application/pdf'
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function verifyGoogleCredentials() {
        GoogleAuth::verifyCredentials(
            $_POST['google_credentials_access_token'],
            $_POST['google_credentials_expires_in'],
            $_POST['google_credentials_id_token']
        );
    }

    function process() {
        $this->conn->begin_transaction();

        try {
            $stmt = $this->conn->prepare('INSERT INTO users (email) VALUES (?)');
            $stmt->bind_param('s', $_POST['email']);

            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
            }

            $userID = $stmt->insert_id;

            $stmt = $this->conn->prepare('
                INSERT INTO businesses (user_id, company_name, company_url, company_description, phone_number, address, zip_code)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ');
            $stmt->bind_param(
                'issssss',
                $userID,
                $_POST['company_name'],
                $_POST['company_url'],
                $_POST['company_description'],
                $_POST['phone_number'],
                $_POST['address'],
                $_POST['zip_code']
            );

            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
            }

            $businessID = $stmt->insert_id;
            
            if (!empty($_FILES['license'])) {
                $targetLicensePath = dirname(__FILE__) . '/../../business_licenses/' . $businessID . '.pdf';

                if (!move_uploaded_file($_FILES["license"]["tmp_name"], $targetLicensePath)) {
                    throw new Exception("Failed to move the license file.");
                }
            }

            $this->conn->commit();

            $jwt = JWT::create($userID);

            $this->ok([
                'token' => $jwt
            ]);
        } catch (Exception $e) {
            $this->conn->rollback();

            throw $e;
        }
    }
}

$controller = new Controller();
$controller->run();