<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();

        $businessID = null;

        if (!empty($_GET['id'])) {
            $businessID = $_GET['id'];
        }

        $this->process($userID, $businessID);
    }

    function process($userID, $businessID) {
        if (!empty($businessID)) {
            $stmt = $this->conn->prepare('SELECT id, user_id, company_name, company_url, company_description, phone_number, address, zip_code FROM businesses WHERE id = ?');
            $stmt->bind_param('i', $businessID);
        } else {
            $stmt = $this->conn->prepare('SELECT id, user_id, company_name, company_url, company_description, phone_number, address, zip_code FROM businesses WHERE user_id = ?');
            $stmt->bind_param('i', $userID);
        }

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch business.');
        }

        $stmt->store_result();

        if ($stmt->num_rows == 0) {
            throw new Exception('Business not found.');
        }
        
        $stmt->bind_result($id, $userID, $companyName, $companyUrl, $companyDescription, $phoneNumber, $address, $zipCode);

        $stmt->fetch();

        $photoPath = null;
        $targetPhotoPath = dirname(__FILE__) . '/../../photos/' . $userID . '.jpg';

        if (file_exists($targetPhotoPath)) {
            $photoPath = '/photos/' . $userID . '.jpg';
        }

        $business = [
            'id' => $id,
            'user_id' => $userID,
            'company_name' => $companyName,
            'company_url' => $companyUrl,
            'company_description' => $companyDescription,
            'phone_number' => $phoneNumber,
            'address' => $address,
            'zip_code' => $zipCode,
            'photo_path' => $photoPath
        ];
        
        $this->ok($business);
    }
}

$controller = new Controller();
$controller->run();