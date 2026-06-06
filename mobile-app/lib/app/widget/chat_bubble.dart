import 'package:flutter/material.dart';
import 'package:refashion/app/modules/chat/model/chat_message_model.dart';
import 'package:refashion/app/utills/color_helper.dart';
import 'package:refashion/app/utills/extension.dart';
import 'package:refashion/app/utills/image_helper.dart';
import 'package:refashion/app/utills/size_utils.dart';
import 'package:refashion/app/utills/text_style_helper.dart';
import 'package:refashion/app/constant/cached_image_view.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSender;
  final bool tail;
  final Color? color;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle? textStyle;
  final BoxConstraints? constraints;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    this.constraints,
    this.color,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(Icons.done, size: 18, color: Color(0xFF97AD8E));
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    Color bubbleColor =
        color ??
        (message.type == 'offer'
            ? ColorHelper.primaryLightColor
            : (isSender
                  ? ColorHelper.primaryLightColor
                  : ColorHelper.primaryLightColor));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isSender
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          CustomPaint(
            painter: _SpecialChatBubbleOne(
              color: bubbleColor,
              alignment: isSender ? Alignment.topRight : Alignment.topLeft,
              tail: tail,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              constraints:
                  constraints ??
                  (message.type == 'offer'
                      ? BoxConstraints.tightFor(
                          width: MediaQuery.of(context).size.width * .5,
                        )
                      : BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .8,
                        )),
              margin: isSender
                  ? stateTick
                        ? EdgeInsets.fromLTRB(8.w, 8.h, 15.w, 8.h)
                        : EdgeInsets.fromLTRB(0.w, 8.h, 24.w, 8.h)
                  : EdgeInsets.fromLTRB(12.w, 8.h, 24.w, 8.h),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: stateTick
                        ? const EdgeInsets.only(right: 20)
                        : EdgeInsets.zero,
                    child: _buildContent(),
                  ),
                  stateIcon != null && stateTick
                      ? Positioned(bottom: 0, right: 0, child: stateIcon)
                      : const SizedBox(width: 1),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildTimeLabel(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (message.type == 'offer') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedImageView(
                imagePath: ImageHelper.icSealPercentage,
                height: 14.r,
                width: 14.r,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 4.w),
              Text(
                message.message,
                style: TextStyleHelper.urRegular400().copyWith(
                  fontSize: 12.sp,
                  color: ColorHelper.headingColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            message.price ?? '',
            style: TextStyleHelper.urSemiBold600().copyWith(
              fontSize: 14.sp,
              color: ColorHelper.headingColor,
            ),
          ),
          if (message.expiresAt != null) ...[
            SizedBox(height: 2.h),
            Text(
              _formatExpiry(message.expiresAt!),
              style: TextStyleHelper.urRegular400().copyWith(
                fontSize: 12.sp,
                color: ColorHelper.headingColor,
              ),
            ),
          ],
        ],
      );
    }
    return Text(
      message.message,
      style:
          textStyle ??
          TextStyleHelper.urRegular400().copyWith(
            color: ColorHelper.headingColor,
            fontSize: 12.sp,
          ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildTimeLabel() {
    return Padding(
      padding: EdgeInsets.only(
        left: isSender ? 0 : 16.w,
        right: isSender ? 16.w : 0,
      ),
      child: Text(
        _formatTime(message.createdAt),
        style: TextStyleHelper.urRegular400().copyWith(
          color: ColorHelper.hintColor,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  String _formatTime(String createdAt) {
    try {
      DateTime dt = DateTime.parse(createdAt).toLocal();
      return dt.hmma();
    } catch (e) {
      return createdAt;
    }
  }

  String _getExpiryLabel(String expiresAt) {
    try {
      final expiryDate = DateTime.parse(expiresAt).toUtc();
      final now = DateTime.now().toUtc();
      final difference = expiryDate.difference(now.toLocal());

      if (difference.isNegative) {
        return 'Offer Expired';
      }

      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);

      if (hours > 0) {
        return 'Expires in ${hours}hrs ${minutes}min';
      } else {
        return 'Expires in ${minutes}min';
      }
    } catch (e) {
      return expiresAt;
    }
  }

  String _formatExpiry(String expiresAt) {
    return _getExpiryLabel(expiresAt);
  }
}

class _SpecialChatBubbleOne extends CustomPainter {
  final Color color;
  final Alignment alignment;
  final bool tail;

  _SpecialChatBubbleOne({
    required this.color,
    required this.alignment,
    required this.tail,
  });

  final double _radius = 4.0;
  final double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path bubblePath = Path();

    if (alignment == Alignment.topRight) {
      if (tail) {
        bubblePath.addRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - _x,
            size.height,
            bottomLeft: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
        );

        final Path tailPath = Path()
          ..moveTo(size.width - _x, 15)
          ..lineTo(size.width - _x, 0)
          ..lineTo(size.width, 0)
          ..close();
        bubblePath.addPath(tailPath, Offset.zero);
      } else {
        bubblePath.addRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - _x,
            size.height,
            bottomLeft: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
        );
      }
    } else {
      if (tail) {
        bubblePath.addRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
          ),
        );

        final Path tailPath = Path()
          ..moveTo(_x, 15)
          ..lineTo(_x, 0)
          ..lineTo(0, 0)
          ..close();
        bubblePath.addPath(tailPath, Offset.zero);
      } else {
        bubblePath.addRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
        );
      }
    }

    canvas.drawPath(bubblePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
