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
                r.id,
                r.title,
                r.description,
                r.created_at,
                r.person_id,
                p.user_id,
                p.first_name,
                p.last_name,
                p.phone_number,
                p.zip_code
            FROM
                requests r
                    JOIN
                people p ON (r.person_id = p.id)
            WHERE
                r.person_id = ?
            ORDER BY
                r.created_at DESC'
        );
        
        $stmt->bind_param('i', $personID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch requests.');
        }
        
        $stmt->store_result();
        $stmt->bind_result(
            $id, $title, $description, $createdAt,
            $personID, $personUserID, $firstName, $lastName, $phoneNumber, $zipCode
        );
        
        $requests = [];

        while ($row = $stmt->fetch()) {
            $request = [
                'id' => $id,
                'title' => $title,
                'description' => $description,
                'created_at' => $createdAt,
                'person' => [
                    'id' => $personID,
                    'first_name' => $firstName,
                    'last_name' => $lastName,
                    'phone_number' => $phoneNumber,
                    'zip_code' => $zipCode
                ]
            ];

            $requests[] = $request;
        }
        
        $this->ok($requests);
    }
}

$controller = new Controller();
$controller->run();