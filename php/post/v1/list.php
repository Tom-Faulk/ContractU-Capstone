<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();
        $this->validateIsPerson($userID);

        $this->process();
    }

    function process() {
        $stmt = $this->conn->prepare('
            SELECT
                p.id,
                p.title,
                p.description,
                p.created_at,
                p.business_id,
                b.user_id,
                b.company_name,
                b.company_url,
                b.company_description,
                b.phone_number,
                b.address,
                b.zip_code
            FROM
                posts p
                    JOIN
                businesses b ON (p.business_id = b.id)
            ORDER BY
                p.created_at DESC
        ');

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch posts.');
        }
        
        $stmt->store_result();
        $stmt->bind_result(
            $id, $title, $description, $createdAt,
            $businessID, $businessUserID, $companyName, $companyUrl, $companyDescription, $phoneNumber, $address, $zipCode
        );
        
        $posts = [];

        while ($row = $stmt->fetch()) {
            $post = [
                'id' => $id,
                'title' => $title,
                'description' => $description,
                'created_at' => $createdAt,
                'business' => [
                    'id' => $businessID,
                    'user_id' => $businessUserID,
                    'company_name' => $companyName,
                    'company_url' => $companyUrl,
                    'company_description' => $companyDescription,
                    'phone_number' => $phoneNumber,
                    'address' => $address,
                    'zip_code' => $zipCode
                ]
            ];

            $posts[] = $post;
        }
        
        $this->ok($posts);
    }
}

$controller = new Controller();
$controller->run();