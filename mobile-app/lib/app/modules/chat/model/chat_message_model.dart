class ChatMessageModel {
  final String message;
  final String createdAt; // UTC ISO String
  final String senderId;
  final String type; // 'text', 'offer'
  final String? price;
  final String? expiresAt;

  ChatMessageModel({
    required this.message,
    required this.createdAt,
    required this.senderId,
    this.type = 'text',
    this.price,
    this.expiresAt,
  });
}
