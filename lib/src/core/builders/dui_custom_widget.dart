import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/basic_shared_utils/color_decoder.dart';

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
      color: const Color(0xFF100F0F),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((widget.json as Map<String, dynamic>)['title'],
                  style: GoogleFonts.inter().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE7E6E2))),
              InkWell(
                onTap: () {
                  setTagIndex();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(24)),
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
          const SizedBox(
            height: 32,
          ),
          FittedBox(
            child: Row(
              children: List.generate(
                (widget.json['toggleItems'][tagIndex]['items'] as List<dynamic>)
                    .length,
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
                      (widget.json['toggleItems'][tagIndex]['items'][index]
                          as Map<String, dynamic>)['timeframe'],
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
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            (widget.json['toggleItems'][tagIndex]['items'][itemIndex]
                as Map<String, dynamic>)['graphData'][0]['name'],
            style: GoogleFonts.inter().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBB9B7),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, bottom: 12),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorDecoder.fromHexString(
                                  (widget.json['toggleItems'][tagIndex]['items']
                                              [itemIndex]
                                          as Map<String, dynamic>)['graphData']
                                      [0]['color'])
                              .withOpacity(0)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8, bottom: 12),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorDecoder.fromHexString(
                              (widget.json['toggleItems'][tagIndex]
                                              ['items']
                                          [itemIndex]
                                      as Map<String, dynamic>)['graphData'][0]
                                  ['valueColor'])),
                      width: MediaQuery.sizeOf(context).width *
                          (((widget.json['toggleItems'][tagIndex]['items']
                                              [itemIndex]
                                          as Map<String, dynamic>)['graphData']
                                      [0]['barWidth'] /
                                  ((tagIndex == 0) ? 1000000 : 1)) /
                              100),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '+ ${(widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][0]['valueText']}',
                  style: GoogleFonts.inter().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE7E6E2),
                  ),
                ),
              )
            ],
          ),
          Text(
            (widget.json['toggleItems'][tagIndex]['items'][itemIndex]
                as Map<String, dynamic>)['graphData'][1]['name'],
            style: GoogleFonts.inter().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBB9B7),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8, bottom: 12),
                      height: 50,
                      decoration: BoxDecoration(
                          color: ColorDecoder.fromHexString(
                                  (widget.json['toggleItems'][tagIndex]['items']
                                              [itemIndex]
                                          as Map<String, dynamic>)['graphData']
                                      [1]['color'])
                              .withOpacity(0),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8, bottom: 12),
                      height: 50,
                      width: MediaQuery.sizeOf(context).width *
                          (((widget.json['toggleItems'][tagIndex]['items']
                                              [itemIndex]
                                          as Map<String, dynamic>)['graphData']
                                      [1]['barWidth'] /
                                  ((tagIndex == 0) ? 1000000 : 1)) /
                              100),
                      decoration: BoxDecoration(
                          color: ColorDecoder.fromHexString(
                              (widget.json['toggleItems'][tagIndex]
                                              ['items']
                                          [itemIndex]
                                      as Map<String, dynamic>)['graphData'][1]
                                  ['valueColor']),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  '+ ${(widget.json['toggleItems'][tagIndex]['items'][itemIndex] as Map<String, dynamic>)['graphData'][1]['valueText']}',
                  style: GoogleFonts.inter().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE7E6E2),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xffFFFFFF).withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4EB3A9),
                      ),
                      Text(
                        ((widget.json['toggleItems'][tagIndex]['items']
                                [itemIndex] as Map<String, dynamic>)['note']
                            as Map<String, dynamic>)['title'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFE7E6E2),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  ((widget.json['toggleItems'][tagIndex]['items'][itemIndex]
                          as Map<String, dynamic>)['note']
                      as Map<String, dynamic>)['subtitle'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter().copyWith(
                    height: 1.5,
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
