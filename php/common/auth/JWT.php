<?php
require_once(dirname(__FILE__) . '/../db/import.php');

class JWT {
    private static $salt = "2598sagf5462pd34fsfq!";

    static function create($userID) {
        $header = self::base64urlEncode(
            json_encode(['typ' => 'JWT', 'alg' => 'HS256'])
        );

        $payload = self::base64urlEncode(
            json_encode(['user_id' => $userID])
        );

        $signature = self::base64urlEncode(
            self::createSignature($header . '.' . $payload)
        );

        $jwt = $header . '.' . $payload . '.' . $signature;

        return $jwt;
    }

    static function parse($jwt) {
        list($encodedHeader, $encodedPayload, $encodedSignature) = explode('.', $jwt);

        $signature = self::base64urlDecode($encodedSignature);
        $signatureVerification = self::createSignature($encodedHeader . '.' . $encodedPayload);

        if ($signature != $signatureVerification) {
            throw new Exception("Invalid authorization token.");
        }

        $payload = json_decode(
            self::base64urlDecode($encodedPayload),
            true
        );
        
        $userID = $payload['user_id'];

        // Verify User ID against DB
        $connection = Database::getConnection();
        $stmt = $connection->prepare('SELECT id FROM users WHERE id = ? LIMIT 1');
        $stmt->bind_param('i', $userID);

        if (!$stmt->execute()) {
            throw new Exception('Could not validate JWT token.');
        }
        
        $stmt->store_result();
        $stmt->bind_result($userID);
        $stmt->fetch();

        if ($stmt->num_rows == 0) {
            throw new Exception("Token OK but user not found.");
        }
        
        return $userID;
    }

    static function createSignature($data) {
        return self::base64urlEncode(
            hash_hmac(
                'sha256',
                $data,
                self::$salt,
                true
            )
        );
    }

    static function base64urlEncode($data) {
        $b64 = base64_encode($data);

        $url = strtr($b64, '+/', '-_');

        return rtrim($url, '=');
    } 

    static function base64urlDecode($data) {
        $b64 = strtr($data, '-_', '+/');
        
        return base64_decode($b64);
    }
}