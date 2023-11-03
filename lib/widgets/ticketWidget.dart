import 'package:flutter/material.dart';

class TicketWidget extends StatefulWidget {
  const TicketWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.isCornerRounded = false,
    this.shadow,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isCornerRounded;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadow;

  @override
  _TicketWidgetState createState() => _TicketWidgetState();
}

class _TicketWidgetState extends State<TicketWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(children: [

        Positioned(
          top: 50,
          child: ClipPath(
            clipper: TicketClipper(),
            child: AnimatedContainer(
              child: widget.child,
              duration: const Duration(seconds: 1),
              width: widget.width,
              height: widget.height-80,
              padding: widget.padding,
              margin: widget.margin,
              decoration: BoxDecoration(
                boxShadow: widget.shadow,
                color: widget.color,
                borderRadius: widget.isCornerRounded ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
              ),
            ),
          ),
        ),
        Positioned(
          left: widget.width*0.35,
          child: CircleAvatar(radius: 50,
              backgroundImage: NetworkImage('https://politics.princeton.edu/sites/default/files/styles/square/public/images/p-5.jpeg?h=87dbaab7&itok=ub6jAL5Q')),
        ),

      ], ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 20.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}