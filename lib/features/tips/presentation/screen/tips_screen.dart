import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/core/theme/font_styles.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> with SingleTickerProviderStateMixin {
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
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tips.shuffle();
    _randomTip = _tips.first;
    
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _generateRandomTip() {
    _animController.reverse().then((_) {
      setState(() {
        _randomTip = _tips[Random().nextInt(_tips.length)];
      });
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        title: Text(
          context.l10n.tips,
          style: FontStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildFeaturedTip(context),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h), // 120 padding for Bottom Nav
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tip = _tips[index];
                  if (tip == _randomTip) return const SizedBox.shrink();
                  return _buildTipCard(context, tip, index);
                },
                childCount: _tips.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedTip(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GestureDetector(
        onTap: _generateRandomTip,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedIdea,
                                color: Colors.yellowAccent,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'إلهام اليوم',
                              style: FontStyles.h4.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedRefresh,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 24.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      _randomTip,
                      style: FontStyles.h3.copyWith(
                        color: Colors.white,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'اضغط للتغيير',
                        style: FontStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String tip, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkBadge01,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                tip,
                style: FontStyles.body.copyWith(
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
