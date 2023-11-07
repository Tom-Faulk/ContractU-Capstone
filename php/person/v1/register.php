<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $json = json_decode(file_get_contents('php://input'), true);
        
        $this->validate($json);

        $this->verifyGoogleCredentials($json);

        $this->process($json);
    }

    function validate($json) {
        if (
            empty($json['google_credentials']['access_token']) ||
            empty($json['google_credentials']['expires_in']) ||
            empty($json['google_credentials']['id_token']) ||
            empty($json['email']) ||
            empty($json['first_name']) ||
            empty($json['last_name']) ||
            empty($json['phone_number']) ||
            empty($json['zip_code'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function verifyGoogleCredentials($json) {
        GoogleAuth::verifyCredentials(
            $json['google_credentials']['access_token'],
            $json['google_credentials']['expires_in'],
            $json['google_credentials']['id_token']
        );
    }

    function process($json) {
        $this->conn->begin_transaction();

        try {
            $stmt = $this->conn->prepare('INSERT INTO users (email) VALUES (?)');
            $stmt->bind_param('s', $json['email']);

            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
            }

            $userID = $stmt->insert_id;

            $stmt = $this->conn->prepare('INSERT INTO people (user_id, first_name, last_name, phone_number, zip_code) VALUES (?, ?, ?, ?, ?)');
            $stmt->bind_param('issss', $userID, $json['first_name'], $json['last_name'], $json['phone_number'], $json['zip_code']);

            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
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