<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();

        $personID = null;

        if (!empty($_GET['id'])) {
            $personID = $_GET['id'];
        }

        $this->process($userID, $personID);
    }

    function process($userID, $personID) {
        if (!empty($personID)) {
            $stmt = $this->conn->prepare('SELECT id, first_name, last_name, phone_number, zip_code FROM people WHERE id = ?');
            $stmt->bind_param('i', $personID);
        } else {
            $stmt = $this->conn->prepare('SELECT id, first_name, last_name, phone_number, zip_code FROM people WHERE user_id = ?');
            $stmt->bind_param('i', $userID);
        }

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch person.');
        }

        $stmt->store_result();

        if ($stmt->num_rows == 0) {
            throw new Exception('Business not found.');
        }
        
        $stmt->bind_result($id, $firstName, $lastName, $phoneNumber, $zipCode);

        $stmt->fetch();

        $photoPath = null;
        $targetPhotoPath = dirname(__FILE__) . '/../../photos/' . $userID . '.jpg';

        if (file_exists($targetPhotoPath)) {
            $photoPath = '/photos/' . $userID . '.jpg';
        }

        $person = [
            'id' => $id,
            'first_name' => $firstName,
            'last_name' => $lastName,
            'phone_number' => $phoneNumber,
            'zip_code' => $zipCode,
            'photo_path' => $photoPath
        ];
        
        $this->ok($person);
    }
}

$controller = new Controller();
$controller->run();