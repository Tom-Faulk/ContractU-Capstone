<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();
        $this->validateIsBusiness($userID);

        $json = json_decode(file_get_contents('php://input'), true);
        
        $this->validate($json);

        $this->process($userID, $json);
    }

    function validate($json) {
        if (
            empty($_POST['company_name']) ||
            empty($_POST['company_url']) ||
            empty($_POST['company_description']) ||
            empty($_POST['phone_number']) ||
            empty($_POST['address']) ||
            empty($_POST['zip_code'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function process($userID, $json) {
        $this->conn->begin_transaction();

        try {
            $stmt = $this->conn->prepare('
                UPDATE businesses
                SET company_name = ?, company_url = ?, company_description = ?, phone_number = ?, address = ?, zip_code = ?
                WHERE user_id = ?
            ');
            $stmt->bind_param(
                'ssssssi',
                $_POST['company_name'],
                $_POST['company_url'],
                $_POST['company_description'],
                $_POST['phone_number'],
                $_POST['address'],
                $_POST['zip_code'],
                $userID
            );
            
            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
            }

            if (!empty($_FILES['photo'])) {
                $targetPhotoPath = dirname(__FILE__) . '/../../photos/' . $userID . '.jpg';

                if (!move_uploaded_file($_FILES["photo"]["tmp_name"], $targetPhotoPath)) {
                    throw new Exception("Failed to move the photo image.");
                }
            }
            
            $this->conn->commit();

            $this->ok(null);
        }
        catch (Exception $e) {
            $this->conn->rollback();

            throw $e;
        }
    }
}

$controller = new Controller();
$controller->run();