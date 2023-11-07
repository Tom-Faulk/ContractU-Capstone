<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $json = json_decode(file_get_contents('php://input'), true);
        
        $userID = $this->validateAuthentication();

        $this->validate($json);

        $this->process($json, $userID);
    }

    function validate($json) {
        if (
            empty($json['recipient_user_id']) ||
            empty($json['subject']) ||
            empty($json['text'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function process($json, $userID) {
        $stmt = $this->conn->prepare('
            INSERT INTO messages (sender_user_id, recipient_user_id, subject, text, created_at)
            VALUES (?, ?, ?, ?, NOW())
        ');
        $stmt->bind_param(
            'iiss',
            $userID,
            $json['recipient_user_id'],
            $json['subject'],
            $json['text']
        );

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