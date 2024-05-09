import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DUICustomWidget extends StatefulWidget {
  final dynamic json;

  const DUICustomWidget({super.key, this.json});

  @override
  State<DUICustomWidget> createState() => _DUICustomWidgetState();
}

class _DUICustomWidgetState extends State<DUICustomWidget> {
  late int tagIndex;
  late int itemIndex;

  @override
  void initState() {
    tagIndex = 0;
    itemIndex = 0;
    super.initState();
  }

  setItemIndex(int index) {
    setState(() {
      itemIndex = index;
    });
  }

  setTagIndex() {
    if (tagIndex == 2) {
      setState(() {
        tagIndex = 0;
      });
    } else {
      setState(() {
        tagIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((widget.json as Map<String, dynamic>)['title'],
                  style: GoogleFonts.inter()
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFFE7E6E2))),
              InkWell(
                onTap: () {
                  setTagIndex();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.expand,
                        color: Color(0xFFE7E6E2),
                      ),
                      Text(
                        widget.json['toggleItems'][tagIndex]['title'],
                        style: GoogleFonts.inter().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFE7E6E2),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: List.generate(
              (widget.json['toggleItems'][tagIndex]['items'] as List<dynamic>).length,
              (index) => InkWell(
                onTap: () {
                  setItemIndex(index);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    (widget.json['toggleItems'][tagIndex]['items'][index] as Map<String, dynamic>)['timeframe'],
                    style: GoogleFonts.inter().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFE7E6E2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(
            (widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][0]['name'],
            style: GoogleFonts.inter().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBB9B7),
            ),
          ),
          Row(
            children: [
              Text(
                (widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][0]
                    ['valueText'],
                style: GoogleFonts.inter().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE7E6E2),
                ),
              )
            ],
          ),
          Text(
            (widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][1]['name'],
            style: GoogleFonts.inter().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBB9B7),
            ),
          ),
          Row(
            children: [
              Text(
                (widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][1]
                    ['valueText'],
                style: GoogleFonts.inter().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE7E6E2),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffffffff1a).withOpacity(0.1)),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4EB3A9),
                    ),
                    Text(
                      ((widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['note']
                          as Map<String, dynamic>)['title'],
                      style: GoogleFonts.inter().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE7E6E2),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  ((widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['note']
                      as Map<String, dynamic>)['subtitle'],
                  style: GoogleFonts.inter().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFBBB9B7),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
