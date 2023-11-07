<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();
        $personID = $this->validateIsPerson($userID);

        $this->process($personID);
    }

    function process($personID) {
        $stmt = $this->conn->prepare('
            SELECT
                a.id,
                a.title,
                a.description,
                UNIX_TIMESTAMP(a.date) AS date,
                a.created_at,
                b.id as business_id,
                b.user_id,
                b.company_name,
                b.company_url,
                b.company_description,
                b.phone_number,
                b.address,
                b.zip_code
            FROM
                appointments a
                    JOIN
                businesses b ON (a.business_id = b.id)
            WHERE
                a.person_id = ?
            ORDER BY
                a.date DESC'
        );
        
        $stmt->bind_param('i', $personID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch requests.');
        }
        
        $stmt->store_result();
        $stmt->bind_result(
            $id, $title, $description, $date, $createdAt,
            $businessID, $businessUserID, $companyName, $companyUrl, $companyDescription, $phoneNumber, $address, $zipCode
        );
        
        $appointments = [];

        while ($row = $stmt->fetch()) {
            $appointment = [
                'id' => $id,
                'title' => $title,
                'description' => $description,
                'date' => $date,
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

            $appointments[] = $appointment;
        }
        
        $this->ok($appointments);
    }
}

$controller = new Controller();
$controller->run();