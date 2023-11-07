<?php
require_once(dirname(__FILE__) . '/../auth/JWT.php');

class BaseController {
    protected $conn;

    function __construct() {
        $this->conn = Database::getConnection();
    }

    function run() {
        try {
            $this->handle();
        } catch (Exception $e) {
            $data = [
                "error" => $e->getMessage()
            ];

            $json = json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

            print($json);

            http_response_code(500);
        }
    }

    function ok($payload) {
        if (!is_null($payload)) {
            $json = json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

            print($json);
        }
    }

    function validateAuthentication() {
        $token = $this->getBearerToken();

        $userID = JWT::parse($token);

        return $userID;
    }

    function validateIsPerson($userID) {
        $stmt = $this->conn->prepare('SELECT id FROM people WHERE user_id = ?');
        $stmt->bind_param('i', $userID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch person.');
        }

        $stmt->store_result();

        if ($stmt->num_rows == 0) {
            throw new Exception('User is not person.');
        }

        $stmt->bind_result($personID);

        $stmt->fetch();

        return $personID;
    }

    function validateIsBusiness($userID) {
        $stmt = $this->conn->prepare('SELECT id FROM businesses WHERE user_id = ?');
        $stmt->bind_param('i', $userID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch business.');
        }

        $stmt->store_result();

        if ($stmt->num_rows == 0) {
            throw new Exception('User is not business.');
        }

        $stmt->bind_result($personID);

        $stmt->fetch();

        return $personID;
    }
    
    function getAuthorizationHeader() {
        $headers = null;
        
        $requestHeaders = apache_request_headers();
        
        $requestHeaders = array_combine(array_map('ucwords', array_keys($requestHeaders)), array_values($requestHeaders));
        
        if (isset($requestHeaders['App-Authorization'])) {
            $headers = trim($requestHeaders['App-Authorization']);
        }

        return $headers;
    }

    function getBearerToken() {
        $headers = $this->getAuthorizationHeader();
        
        if (empty($headers)) {
            return;
        }

        if (preg_match('/Bearer\s(\S+)/', $headers, $matches)) {
            return $matches[1];
        }
        
        return null;
    }
}