<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $this->validateAuthentication();

        $this->process();
    }

    function process() {
        $query = "";

        if (!empty($_GET['query'])) {
            $query = $_GET['query'];
        }

        $query = '%' . $query . '%';
        
        $stmt = $this->conn->prepare('
            SELECT
                id,
                user_id,
                company_name,
                company_url,
                company_description,
                phone_number,
                address,
                zip_code
            FROM
                businesses
            WHERE
                company_name LIKE ?
                    OR
                company_description LIKE ?
        ');
        $stmt->bind_param('ss', $query, $query);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch businesses.');
        }
        
        $stmt->store_result();
        $stmt->bind_result($id, $userID, $companyName, $companyUrl, $companyDescription, $phoneNumber, $address, $zipCode);
        
        $businesses = [];

        while ($row = $stmt->fetch()) {
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

            $businesses[] = $business;
        }
        
        $this->ok($businesses);
    }
}

$controller = new Controller();
$controller->run();