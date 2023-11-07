<?php
require_once(dirname(__FILE__) . '/../../common/import.php');

class Controller extends BaseController {
    function handle() {
        $userID = $this->validateAuthentication();

        $this->process($userID);
    }

    function process($userID) {
        // Inbox

        $stmt = $this->conn->prepare('
            SELECT
                m.id,
                COALESCE(
                    IF(sp.first_name IS NULL, NULL, CONCAT(sp.first_name, " ", sp.last_name)),
                    sb.company_name
                ) AS sender_name,
                COALESCE(
                    IF(rp.first_name IS NULL, NULL, CONCAT(rp.first_name, " ", rp.last_name)),
                    rb.company_name
                ) AS recipient_name,
                m.subject,
                m.text
            FROM
                messages m
                    LEFT JOIN
                people sp ON (m.sender_user_id = sp.user_id)
                    LEFT JOIN
                businesses sb ON (m.sender_user_id = sb.user_id)
                    LEFT JOIN
                people rp ON (m.recipient_user_id = rp.user_id)
                    LEFT JOIN
                businesses rb ON (m.recipient_user_id = rb.user_id)
            WHERE
                m.recipient_user_id = ?
            ORDER BY
                m.created_at DESC
        ');

        $stmt->bind_param('i', $userID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch inbox messages.');
        }
        
        $stmt->store_result();
        $stmt->bind_result($id, $senderName, $recipientName, $subject, $text);
        
        $inbox = [];

        while ($row = $stmt->fetch()) {
            $message = [
                'id' => $id,
                'sender_name' => $senderName,
                'recipient_name' => $recipientName,
                'subject' => $subject,
                'text' => $text
            ];

            $inbox[] = $message;
        }
        
        // Sent

        $stmt = $this->conn->prepare('
            SELECT
                m.id,
                COALESCE(
                    IF(sp.first_name IS NULL, NULL, CONCAT(sp.first_name, " ", sp.last_name)),
                    sb.company_name
                ) AS sender_name,
                COALESCE(
                    IF(rp.first_name IS NULL, NULL, CONCAT(rp.first_name, " ", rp.last_name)),
                    rb.company_name
                ) AS recipient_name,
                m.subject,
                m.text
            FROM
                messages m
                    LEFT JOIN
                people sp ON (m.sender_user_id = sp.user_id)
                    LEFT JOIN
                businesses sb ON (m.sender_user_id = sb.user_id)
                    LEFT JOIN
                people rp ON (m.recipient_user_id = rp.user_id)
                    LEFT JOIN
                businesses rb ON (m.recipient_user_id = rb.user_id)
            WHERE
                m.sender_user_id = ?
            ORDER BY
                m.created_at DESC
        ');

        $stmt->bind_param('i', $userID);

        if (!$stmt->execute()) {
            throw new Exception('Could not fetch inbox messages.');
        }
        
        $stmt->store_result();
        $stmt->bind_result($id, $senderName, $recipientName, $subject, $text);
        
        $sent = [];

        while ($row = $stmt->fetch()) {
            $message = [
                'id' => $id,
                'sender_name' => $senderName,
                'recipient_name' => $recipientName,
                'subject' => $subject,
                'text' => $text
            ];

            $sent[] = $message;
        }

        $messages = [
            'inbox' => $inbox,
            'sent' => $sent
        ];

        $this->ok($messages);
    }
}

$controller = new Controller();
$controller->run();