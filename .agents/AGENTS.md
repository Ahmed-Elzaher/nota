# قواعد ومعايير التطوير لتطبيقات Flutter (Clean Architecture)

تم إعداد هذه القواعد بناءً على المعايير العالمية (Global Standards) في Flutter مع الاعتماد على أفضل الممارسات المطبقة في مشاريع سابقة (مثل serv5-day-i) لتكون مرجعاً ثابتاً لأي وكيل ذكاء اصطناعي (AI Agent). يجب الالتزام التام بها عند كتابة أو تعديل أي كود.

---

## 1. المبادئ الأساسية (Core Principles)
- **Feature-first Structure**: الكود مقسم بناءً على الميزات (Features). كل ميزة مستقلة تماماً وتحتوي على طبقاتها الخاصة (presentation, domain, data). لا يوجد تداخل بين الميزات إلا عبر مجلد `core`.
- **Separation of Concerns**: واجهة المستخدم (UI) لا تعرف شيئاً عن منطق العمل (Business Logic)، ومنطق العمل لا يعرف شيئاً عن مصادر البيانات (API/DB).
- **Single Responsibility**: كل ملف أو صنف (Class) يقوم بوظيفة واحدة فقط وله سبب واحد للتغيير.
- **Immutability**: استخدام `final` و `const` دائماً. فئات الحالة (State Classes) يجب أن تكون غير قابلة للتعديل (Immutable) عبر `freezed` أو `copyWith`.
- **No Magic Values**: يمنع استخدام نصوص، أرقام، ألوان، أو مسافات صلبة (Hardcoded) داخل الكود. يتم استدعاؤها جميعاً من ثوابت (Constants) أو الثيم (Theme) أو الترجمة (Localization).

---

## 2. هيكلة المجلدات (Folder Structure)
يجب استخدام **صيغة المفرد (Singular Naming)** في تسمية مجلدات الطبقات كما هو متبع كمعيار نظيف:

```text
lib/
  core/
    constants/       # (e.g., api_constants.dart)
    database/        # (Local storage setups)
    di/              # (Dependency Injection - GetIt)
    localization/    # (l10n logic)
    networking/      # (API Service, Interceptors)
    router/          # (AppRouter, route paths)
    services/        # (Third-party integrations)
    theme/           # (app_theme.dart, app_colors.dart, font_styles.dart)
    utils/           # (extensions, errors, consts like image_paths)
    widgets/         # (Shared global widgets)

  features/
    <feature_name>/
      data/
        data_source/ # (remote / local data sources)
        model/       # (DTOs, extends entity, fromJson/toJson)
        repository/  # (Repository Implementations)
      domain/
        entity/      # (Pure Dart data objects)
        params/      # (Use Case parameters)
        repository/  # (Abstract Repository Interfaces)
        use_case/    # (Business Logic execution)
      presentation/
        controller/  # (Cubit / Bloc classes)
        screen/      # (Main UI pages)
        widget/      # (Widgets specific to this feature only)
```
**قاعدة الاعتمادية:** الاتجاه دائماً هو: `presentation` ← يكلم ← `domain` ← يكلم ← `data`. طبقة الـ `domain` لا تعرف شيئاً عن Flutter أو Dio أو أي مكتبة خارجية.

---

## 3. تقسيم الواجهات (Widget Splitting)
- **أقصى حد للملف 150-200 سطر**. إذا تجاوزت ذلك، توقف وقسم الكود فوراً.
- الشاشة الرئيسية (Screen) هي **طبقة تجميع (Composition Layer)** فقط (Scaffold + استدعاء لويدجتس أخرى). يمنع وضع تفاصيل UI معقدة بداخلها.
- كل عنصر له حالته الخاصة أو يمكن فصله بصرياً يجب أن يكون في ملف منفصل داخل مجلد `widget` الخاص بالميزة.
- اطرح هذا السؤال قبل الكتابة: "هل يمكنني فصل هذا الجزء ليكون أكثر ترتيباً؟" إذا كانت الإجابة نعم، افصله. يجب استخدام `SizedBox(height: 16.h)` (أو مسافات ثابتة من Dimens) للفصل بين العناصر لتجنب التداخل.

---

## 4. إدارة الحالة (State Management - Cubit/Bloc)
- يمنع كتابة Business Logic أو استدعاءات Async داخل الدالة `build()`.
- كل شاشة/ميزة معقدة لها `Cubit` أو `Bloc` خاص بها. يمنع استخدام `setState` إلا في الأمور البصرية البسيطة جداً (مثل تبديل إظهار كلمة المرور).
- الحالات (States) يجب أن تُبنى باستخدام `sealed classes` أو `freezed` وتغطي الحالات الأساسية: `Initial`, `Loading`, `Success`, `Failure`. (يمنع استخدام الـ boolean flags المتناثرة مثل `isLoading`).
- الـ Cubit لا يعرف شيئاً عن واجهة المستخدم ولا يتعامل مع `BuildContext` إلا في الحالات القصوى والمبررة.

---

## 5. طبقة البيانات والشبكات (Data & API Layer)
- طبقة الـ `model` تحتوي على وظائف `fromJson`/`toJson` وترث (extends) من الـ `entity`.
- مستودع البيانات (Repository) يعيد دائماً `Either<Failure, T>` (باستخدام مكتبات مثل dartz أو fpdart). يمنع تسريب الـ Exceptions مباشرة لطبقة الـ UI.
- جميع مكالمات API يجب أن تكون في `data_source`، ولا يتم استدعاؤها أبداً من الـ Cubit مباشرة.
- في حالة التعامل مع Endpoints غير مؤكدة، استخدم تعليق `// TODO: verify API endpoint/response shape`.

---

## 6. قواعد التسمية (Naming Conventions)
| النوع | الصيغة | مثال |
| --- | --- | --- |
| الملفات (Files) | `snake_case.dart` | `product_card.dart` |
| الأصناف (Classes) | `PascalCase` | `ProductCard` |
| المتغيرات/الدوال | `camelCase` | `fetchUserData()` |
| الثوابت (Constants) | `camelCase` (or inside class) | `AppColors.primary` |
| الحالات (States) | اسم معبر تماماً | `ProductLoading`, `ProductLoadFailure` |
- **تنبيه**: يمنع استخدام أسماء عامة ومبهمة مثل `helper.dart` أو `widget1.dart`.

---

## 7. اللغة والتوطين والسمات (Localization & Theming)
- **لغة التطبيق الافتراضية**: يجب أن تكون كل النصوص الظاهرة للمستخدم باللغة **العربية حصراً** (إلا إذا طلب غير ذلك)، واتجاه التطبيق الافتراضي من اليمين لليسار (RTL). يمنع استخدام كلمات مثل "Note, Save, Add" ويجب استبدالها بـ "نص، حفظ، إضافة".
- يمنع كتابة ألوان بصيغة Hex `Color(0xFF...)` داخل الـ Widgets مباشرة. يجب سحبها دائماً من `AppColors` أو `Theme.of(context)`.
- الأبعاد والخطوط تستدعى من ثوابت مثل `AppDimens` أو `FontStyles` (ويفضل استخدام `flutter_screenutil` مثل `.sp`، `.h`، `.w`).

---

## 8. التعامل مع الأخطاء وحالات التحميل (Error & Edge Cases)
- أي ويدجيت يتعامل مع بيانات Async يجب أن يغطي ثلاث حالات مرئية: `Loading`, `Empty`, `Error`.
- يفضل استخدام Shared Widgets عامة مثل `AppLoader` أو `ErrorRetryView`.
- التنبيهات (SnackBars) ورسائل الخطأ يجب أن تكون عربية، واضحة للمستخدم ولا تحتوي على مصطلحات تقنية معقدة.
- يمنع ترك كتل `try/catch` فارغة أو استخدام `print()` للإنتاج؛ استخدم نظام تسجيل (Logger) مخصص.

---

## 9. التعليقات (Comments) - باللغة العربية
- عند إجراء أي تعديل جوهري (إضافة ميزة، Refactoring)، **يجب إضافة تعليقات توضيحية باللغة العربية** لشرح الأجزاء المعقدة.
- لا تضف تعليقات للأشياء البديهية (مثل `// بناء الواجهة` فوق `build`).
- أي نواقص يجب توضيحها بتعليق واضح باللغة الإنجليزية/العربية `// TODO: [وصف النقص بوضوح]`.

---

## 10. قواعد استخدام أيقونات (HugeIcons)
هذه القاعدة **حاسمة (CRITICAL)** لتجنب أخطاء النوع (Type Mismatch):
- قيم `HugeIcons.*` **ليست** من نوع `IconData`. هي من نوع مخصص للمكتبة `List<List<dynamic>>`.
- **يمنع منعاً باتاً** استخدام قيم HugeIcons داخل الـ Widget القياسي `Icon(...)`.
- **الاستخدام الصحيح**:
  ```dart
  import 'package:hugeicons/hugeicons.dart';

  HugeIcon(
    icon: HugeIcons.strokeRoundedHome01,
    color: AppColors.iconDefault, // لا تستخدم ألوان Hardcoded
    size: 24.sp,
  )
  ```
- في حال تطلب ويدجيت (مثل بعض مكتبات الطرف الثالث) متغير من نوع `IconData` حصراً، فلا تقم بفرض Cast للـ HugeIcons، بل استخدم `Icons.xyz` (Material) بديلة وضع تعليق:
  `// TODO: This API requires IconData — HugeIcons not compatible here, using fallback.`
- عند إنشاء ويدجيت مخصص يأخذ أيقونة، اجعل نوع المتغير `dynamic` (أو النوع الدقيق من المكتبة) وليس `IconData`:
  ```dart
  final dynamic icon; // For HugeIcons
  ```

---

## 11. حقن التبعية وإدارة الـ Dependencies (DI)
- الاعتماد التام على `GetIt` للـ Dependency Injection (DI) في جميع الطبقات (Services, Repositories, UseCases, Cubits).
- تسجيل الاعتماديات يتم بشكل منظم في ملفات `di.dart` أو بداخل مجلد الـ `di`.

---

## 12. قائمة المراجعة الذاتية للوكيل (Self-Review Checklist)
قبل إنهاء أي مهمة أو كتابة أي كود، تأكد من:
- [ ] هل يتجاوز أي ملف 200 سطر؟ -> قسّمه فوراً.
- [ ] هل توجد أي نصوص، أرقام أو ألوان Hardcoded؟
- [ ] هل تم تغطية جميع حالات الـ Async (تحميل / خطأ / فارغ)؟
- [ ] هل تم تطبيق الاتجاه الصحيح للطبقات (Presentation -> Domain <- Data)؟
- [ ] هل استُخدمت `HugeIcon` بشكل صحيح (بدلاً من الإسناد لـ IconData)؟
- [ ] هل الكود والنصوص المرئية باللغة العربية بشكل افتراضي؟
- [ ] هل التعليقات على الأجزاء المعقدة مكتوبة باللغة العربية؟
MVVM 
SOLID
data domain persetation لاي فيتشر جديد