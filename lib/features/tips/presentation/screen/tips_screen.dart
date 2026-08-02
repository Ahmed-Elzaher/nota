import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final List<String> _tips = [
    "قسّم المهام الكبيرة إلى أجزاء صغيرة يسهل إنجازها.",
    "استخدم تقنية بومودورو (25 دقيقة عمل، 5 دقائق راحة) لزيادة التركيز.",
    "اكتب أهدافك اليومية في الليلة السابقة لتوفير وقتك في الصباح.",
    "تجنب تعدد المهام (Multitasking) وركز على مهمة واحدة في كل مرة.",
    "خذ قسطاً كافياً من النوم، العقل المجهد لا يبدع.",
    "استخدم الخرائط الذهنية لتبسيط الأفكار المعقدة.",
    "كافئ نفسك بعد كل إنجاز، حتى لو كان صغيراً.",
    "تعلم كيف تقول 'لا' للمشتتات التي تسرق وقتك.",
    "اجعل بيئة عملك منظمة وخالية من الفوضى.",
    "خصص وقتاً يومياً لقراءة شيء جديد في مجالك.",
    "لا تنتظر الإلهام لتبدأ، ابدأ وسيأتي الإلهام لاحقاً.",
    "احتفظ بمفكرة صغيرة دائماً لتدوين الأفكار المفاجئة.",
    "تتبع وقتك لتعرف أين يضيع وتصلحه.",
    "استمع لموسيقى هادئة أو أصوات الطبيعة لتزيد من تركيزك.",
    "تجنب تصفح وسائل التواصل الاجتماعي في الساعات الأولى من الصباح.",
    "مارس الرياضة بانتظام، العقل السليم في الجسم السليم.",
    "اشرب كميات كافية من الماء يومياً للحفاظ على نشاط دماغك.",
    "راجع إنجازاتك الأسبوعية لتعرف مدى تقدمك.",
    "لا تخف من ارتكاب الأخطاء، فهي فرصة للتعلم.",
    "كن مرناً، الخطط تتغير والمهم هو الاستمرار نحو الهدف."
  ];

  late String _randomTip;

  @override
  void initState() {
    super.initState();
    _tips.shuffle(); // Shuffle the tips on start
    _randomTip = _tips.first;
  }

  void _generateRandomTip() {
    setState(() {
      _randomTip = _tips[Random().nextInt(_tips.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tips, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Featured Random Tip
          Padding(
            padding: EdgeInsets.all(16.w),
            child: GestureDetector(
              onTap: _generateRandomTip,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const HugeIcon(icon: HugeIcons.strokeRoundedIdea, color: Colors.yellow, size: 28),
                        SizedBox(width: 8.w),
                        Text(
                          'نصيحة اليوم',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      _randomTip,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'اضغط للتغيير',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                if (_tips[index] == _randomTip) return const SizedBox(); // Skip the featured tip
                
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 2,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            _tips[index],
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
