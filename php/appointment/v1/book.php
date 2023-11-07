<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $json = json_decode(file_get_contents('php://input'), true);
        
        $userID = $this->validateAuthentication();
        $personID = $this->validateIsPerson($userID);

        $this->validate($json);

        $this->process($json, $personID);
    }

    function validate($json) {
        if (
            empty($json['business_id']) ||
            empty($json['title']) ||
            empty($json['description']) ||
            empty($json['date'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function process($json, $personID) {
        $stmt = $this->conn->prepare('INSERT INTO appointments (business_id, person_id, title, description, date, created_at) VALUES (?, ?, ?, ?, FROM_UNIXTIME(?), NOW())');
        $stmt->bind_param('iissi', $json['business_id'], $personID, $json['title'], $json['description'], $json['date']);

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