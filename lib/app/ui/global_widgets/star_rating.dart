import 'package:flutter/material.dart';
class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Function(double)? onRatingChanged; 
  const StarRating({
    super.key,
    required this.rating,
    this.size = 24.0,
    this.onRatingChanged, 
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData;
        Color iconColor = Colors.pink; 
        if (index < rating.floor()) {
          iconData = Icons.star; 
        } else if (index < rating) {
          iconData = Icons.star_half; 
        } else {
          iconData = Icons.star_border; 
        }
        return GestureDetector( 
          onTap: onRatingChanged == null
              ? null
              : () {
                  onRatingChanged!(index + 1.0);
                },
          child: Icon(
            iconData,
            color: iconColor,
            size: size,
          ),
        );
      }),
    );
  }
}