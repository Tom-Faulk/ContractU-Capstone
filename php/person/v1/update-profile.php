<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();
        $this->validateIsPerson($userID);

        $json = json_decode(file_get_contents('php://input'), true);
        
        $this->validate();

        $this->process($userID, $json);
    }

    function validate() {
        if (
            empty($_POST['first_name']) ||
            empty($_POST['last_name']) ||
            empty($_POST['phone_number']) ||
            empty($_POST['zip_code'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function process($userID) {
        $this->conn->begin_transaction();

        try {
            $stmt = $this->conn->prepare('UPDATE people SET first_name = ?, last_name = ?, phone_number = ?, zip_code = ? WHERE user_id = ?');
            $stmt->bind_param('ssssi', $_POST['first_name'], $_POST['last_name'], $_POST['phone_number'], $_POST['zip_code'], $userID);
            
            if (!$stmt->execute()) {
                throw new Exception($stmt->error);
            }

            if (!empty($_FILES['photo'])) {
                $targetPhotoPath = dirname(__FILE__) . '/../../photos/' . $userID . '.jpg';

                if (!move_uploaded_file($_FILES['photo']['tmp_name'], $targetPhotoPath)) {
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