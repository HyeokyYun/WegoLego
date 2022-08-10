import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:livq/widgets/common_widget.dart';

class guidePage extends StatefulWidget {
  const guidePage({Key? key}) : super(key: key);

  @override
  _guidePageState createState() => _guidePageState();
}

class _guidePageState extends State<guidePage> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      _step1(),
      _step2(),
      _step3(),
    ];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "사용 설명서",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.0.h),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4 * 3,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return steps[index];
                  },
                  loop: false,
                  autoplay: false,
                  itemCount: 3,
                  viewportFraction: 1.0,
                  scale: 0.9,

                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.grey[200],
                        activeColor: Color(0XFF874BD9)),
                  ),

                ),
                //
              )
            ],
          ),
        ));
  }
}

Widget _step1() {
  return Column(children: [
    Image.asset(
      "assets/home/icons.png",
      height: 218.h,
      width: 205.w,
    ),
    sizedBoxWidget(0,30),
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBoxWidget(5,0),
          Column(children: [
            sizedBoxWidget(0,6),
            Image.asset(
              "assets/home/1.png",
            ),
          ]),
          textWidget(
            '''카테고리를
선택해보세요''',TextStyle(fontSize: ScreenUtil().setSp(18)),
          ),
          textWidget('''지금 도움이 필요한 분야가
무엇인지 선택해주세요
대중교통, 공부, 운동, 음식, 
애완동물 등 여러분야의 
문제에 답변해드릴게요 ''',TextStyle())
        ])
  ]);
}

Widget _step2() {
  return Column(children: [
    Column(children: [
      Image.asset(
        "assets/home/ask_button.png",
        height: 218.h,
        width: 205.w,
      ),
      sizedBoxWidget(0,32),
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBoxWidget(5,0),
            Column(children: [
              sizedBoxWidget(0,6),
              Image.asset(
                "assets/home/2.png",
              ),
            ]),
            textWidget(
              '''
질문자가 되어
도움을
받아보세요 ''',TextStyle(fontSize: ScreenUtil().setSp(18)),
            ),
            textWidget('''궁금한 분야를 답변자에게
자신의 영상을 공유하며 
실시간으로 직접 묻고 
답변을 받을 수 있어요''',TextStyle())
          ])
    ]),
  ]);
}

Widget _step3() {
  return Column(children: [
    Column(children: [
      sizedBoxWidget(0,100),
      Container(
        height: 74.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 17.h,
                    child: SvgPicture.asset(
                      "assets/my_page/heartIcon.svg",
                    ),
                  ),
                  sizedBoxWidget(0, 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget("받은 하트",TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                      sizedBoxWidget(2,0),
                      Column(
                        children: [
                          sizedBoxWidget(0, 5)
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 19.h,
                    child: Image.asset(
                      "assets/my_page/yellow_i.png",
                    ),
                  ),
                  sizedBoxWidget(0, 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        "응답 횟수", TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                      sizedBoxWidget(2, 0),
                      Column(
                        children: [
                          sizedBoxWidget(0,5),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 18.h,
                    child: Image.asset(
                      "assets/my_page/star_icon.png",
                    ),
                  ),
                  sizedBoxWidget(0, 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        "질문 횟수",TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                      ),
                      sizedBoxWidget(2, 0),
                      Column(
                        children: [
                          sizedBoxWidget(0, 5),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      sizedBoxWidget(0, 100),
      Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxWidget(5, 0),
              Column(children: [
                sizedBoxWidget(0, 6),
                Image.asset(
                  "assets/home/3.png",
                ),
              ]),
              Column(
                children: [
                  textWidget(
                    '''답변자가 되어
도움을 주세요 ''',TextStyle(fontSize: ScreenUtil().setSp(18)),
                  ),
                  sizedBoxWidget(0, 70),
                  Image.asset(
                    "assets/home/Vector.png",
                  )
                ],
              ),
              Text('''실시간 질문방에 입장하여
다른 사람들의 질문에
바로 답변할 수 있어요!
자신있는 분야에 참여해서 
도움을 주세요

직접 화면에 그리는 기능을
다른 사람들의 질문에
바로 답변할 수 있어요!
자신있는 분야에 참여해서 
도움을 주세요
'''),
            ]),
        sizedBoxWidget(0, 32),
      ])
    ]),
  ]);
}
