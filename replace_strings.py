import os
import re

replacements = {
    'splash_screen.dart': [
        (r"'نُوتَة'", "context.l10n.appName"),
        (r"'عقلك الثاني'", "context.l10n.yourSecondBrain"),
    ],
    'settings_screen.dart': [
        (r"'سيتم تفعيل تغيير اللغة قريباً'", "context.l10n.languageChangeSoon"),
        (r"'الإعدادات'", "context.l10n.settings"),
        (r"'الإشعارات والتذكير اليومي'", "context.l10n.notificationsAndDailyReminder"),
        (r"'تلقي إشعارات لتذكيرك بمراجعة مهامك'", "context.l10n.receiveNotificationsToRemindYou"),
        (r"'لغة التطبيق'", "context.l10n.appLanguage"),
        (r"'اختر لغتك المفضلة'", "context.l10n.choosePreferredLanguage"),
        (r"'العربية'", "context.l10n.arabic"),
        (r"'English'", "context.l10n.english"),
        (r"activeColor:", "activeThumbColor:"),
    ],
    'add_item_bottom_sheet.dart': [
        (r"'إضافة ملاحظة جديدة'", "context.l10n.addNewNote"),
        (r"'نص'", "context.l10n.text"),
        (r"'رابط'", "context.l10n.link"),
        (r"'القسم'", "context.l10n.category"),
        (r"'أخرى'", "context.l10n.catOther"),
    ]
}

def replace_in_file(filepath, replacements):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        modified = False
        for old, new in replacements:
            if re.search(old, content):
                content = re.sub(old, new, content)
                modified = True
        
        if modified:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"Updated: {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")

def main():
    lib_dir = os.path.join(os.path.dirname(__file__), 'lib')
    
    for root, _, files in os.walk(lib_dir):
        for file in files:
            if file.endswith('.dart') and file in replacements:
                filepath = os.path.join(root, file)
                replace_in_file(filepath, replacements[file])

if __name__ == "__main__":
    main()
