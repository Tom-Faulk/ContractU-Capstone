<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $json = json_decode(file_get_contents('php://input'), true);
        
        $userID = $this->validateAuthentication();
        $businessID = $this->validateIsBusiness($userID);

        $this->validate($json);

        $this->process($json, $businessID);
    }

    function validate($json) {
        if (
            empty($json['title']) ||
            empty($json['description'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function process($json, $businessID) {
        $stmt = $this->conn->prepare('INSERT INTO posts (business_id, title, description, created_at) VALUES (?, ?, ?, NOW())');
        $stmt->bind_param('iss', $businessID, $json['title'], $json['description']);

        if (!$stmt->execute()) {
            throw new Exception($stmt->error);
        }

        $this->ok([
            "success" => true
        ]);
    }
}

$controller = new Controller();
$controller->run();