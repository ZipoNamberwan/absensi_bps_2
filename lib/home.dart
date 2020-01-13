import 'package:absensi_bps_2/classes/statistik.dart';
import 'package:absensi_bps_2/classes/statistik_tile_widget.dart';
import 'package:absensi_bps_2/src/color.dart';
import 'package:absensi_bps_2/src/default_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'classes/detail_absensi.dart';
import 'classes/keterangan_absensi.dart';
import 'classes/rounded_image_widget.dart';

class HomePage extends StatefulWidget {
  final Pegawai pegawai;
  final List<DetailAbsensi> details;
  final Statistik stat;
  final double height;

  HomePage(
      {@required this.pegawai,
      @required this.stat,
      this.height,
      @required this.details});

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

/*    final logoHeight = screenHeight * 0.4;

    const String logo = "images/bps.svg";*/

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: <Widget>[
          /*Transform.translate(
          offset: Offset(screenWidth * 0.4, 10),
          child: Transform.rotate(
            angle: -0.1,
            child: SvgPicture.asset(
              logo,
              height: logoHeight,
              color: logoTintColor,
            ),
          ),
        ),*/
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RoundedImageWidget(
                                imagePath: widget.pegawai.foto,
                                showRanking: false,
                                isOnline: true,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Halo, ",
                                      style: userNameTextStyle,
                                    ),
                                    Text(
                                      widget.pegawai.nama + "!",
                                      style: userNameTextStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, bottom: 16, top: 16),
                        child: Material(
                          elevation: 4,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 16.0,
                                bottom: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Absensi Hari Ini ",
                                      style: hoursPlayedLabelTextStyle,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: firstColor,
                                      ),
                                      child: Center(
                                          child: Column(
                                        children: <Widget>[
                                          Text(
                                            widget.details[0].time,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "datang",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      )),
                                      padding: EdgeInsets.all(10),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: secondColor,
                                      ),
                                      child: Center(
                                          child: Column(
                                        children: <Widget>[
                                          Text(
                                            widget.details[1].time,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "pulang",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      )),
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 15),
                        child: Text(
                          "Statistik Bulan Ini",
                          style: headingOneTextStyle,
                        ),
                      ),
                      StatistikTile(
                        screenWidth: screenWidth,
                        title: "Terlambat",
                        subTitle: "Absen lebih dari 7.30",
                        frequency: widget.stat.telatFreq,
                      ),
                      StatistikTile(
                        screenWidth: screenWidth,
                        title: "Sakit",
                        subTitle: "",
                        frequency: widget.stat.sakitFreq,
                      ),
                      StatistikTile(
                        screenWidth: screenWidth,
                        title: "Cuti",
                        subTitle: "",
                        frequency: widget.stat.cutiFreq,
                      ),
                      StatistikTile(
                        screenWidth: screenWidth,
                        title: "Tugas",
                        subTitle: "",
                        frequency: widget.stat.tugasFreq,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.dehaze,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.search,
                  color: primaryTextColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
