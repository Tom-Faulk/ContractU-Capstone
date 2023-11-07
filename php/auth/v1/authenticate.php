<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $json = json_decode(file_get_contents('php://input'), true);

        $this->validate($json);

        $this->verifyGoogleCredentials($json);

        $this->process($json);
    }

    function validate($json) {
        if (
            empty($json['email']) ||
            empty($json['google_credentials']['access_token']) ||
            empty($json['google_credentials']['expires_in']) ||
            empty($json['google_credentials']['id_token'])
        ) {
            throw new Exception("Required parameters are missing.");
        }
    }

    function verifyGoogleCredentials($json) {
        GoogleAuth::verifyCredentials(
            $json['google_credentials']['access_token'],
            $json['google_credentials']['expires_in'],
            $json['google_credentials']['id_token']
        );
    }

    function process($json) {
        $stmt = $this->conn->prepare('
            SELECT u.id,
                NOT ISNULL(p.id) AS is_person,
                NOT ISNULL(b.id) AS is_business
            FROM
                users u
                    LEFT JOIN
                people p ON p.user_id = u.id
                    LEFT JOiN
                businesses b ON b.user_id = u.id
            WHERE
                email = ?
            LIMIT 1'
        );
        $stmt->bind_param('s', $json['email']);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch user.');
        }
        
        $stmt->store_result();
        $stmt->bind_result($userID, $isPerson, $isBusiness);
        $stmt->fetch();

        if ($stmt->num_rows == 0) {
            $this->ok([
                'token' => null
            ]);

            return;
        }

        $userType = null;

        if ($isPerson) {
            $userType = 'person';
        } else if ($isBusiness) {
            $userType = 'business';
        } else {
            throw new Exception('Unknown user type.');
        }

        $token = JWT::create($userID);

        $this->ok([
            'token' => $token,
            'user_type' => $userType
        ]);
    }
}

$controller = new Controller();
$controller->run();