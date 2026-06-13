import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru'),
    Locale('uk'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'ConstructManager'**
  String get app_title;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @no_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get no_account;

  /// No description provided for @has_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get has_account;

  /// No description provided for @repeat_password.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeat_password;

  /// No description provided for @update_email.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get update_email;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @new_email.
  ///
  /// In en, this message translates to:
  /// **'New Email'**
  String get new_email;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'ConstructManager'**
  String get home_title;

  /// No description provided for @email_verified.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get email_verified;

  /// No description provided for @email_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get email_not_verified;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verify_email;

  /// No description provided for @resend_verification.
  ///
  /// In en, this message translates to:
  /// **'Resend verification'**
  String get resend_verification;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @ukrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get ukrainian;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @supabase_config.
  ///
  /// In en, this message translates to:
  /// **'Supabase Configuration'**
  String get supabase_config;

  /// No description provided for @supabase_url.
  ///
  /// In en, this message translates to:
  /// **'Supabase URL'**
  String get supabase_url;

  /// No description provided for @supabase_key.
  ///
  /// In en, this message translates to:
  /// **'Supabase Anon Key'**
  String get supabase_key;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @my_projects.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get my_projects;

  /// No description provided for @create_project.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get create_project;

  /// No description provided for @edit_project.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get edit_project;

  /// No description provided for @delete_project.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get delete_project;

  /// No description provided for @project_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get project_title;

  /// No description provided for @project_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get project_address;

  /// No description provided for @project_type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get project_type;

  /// No description provided for @responsibles.
  ///
  /// In en, this message translates to:
  /// **'Responsibles'**
  String get responsibles;

  /// No description provided for @select_responsible.
  ///
  /// In en, this message translates to:
  /// **'Select responsible'**
  String get select_responsible;

  /// No description provided for @no_projects.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get no_projects;

  /// No description provided for @stage_preparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get stage_preparation;

  /// No description provided for @stage_in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get stage_in_progress;

  /// No description provided for @stage_finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get stage_finished;

  /// No description provided for @stage_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get stage_cancelled;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @budget_item.
  ///
  /// In en, this message translates to:
  /// **'Budget Item'**
  String get budget_item;

  /// No description provided for @add_budget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get add_budget;

  /// No description provided for @edit_budget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get edit_budget;

  /// No description provided for @budget_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get budget_title;

  /// No description provided for @budget_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get budget_description;

  /// No description provided for @budget_value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get budget_value;

  /// No description provided for @no_budget_items.
  ///
  /// In en, this message translates to:
  /// **'No budget items'**
  String get no_budget_items;

  /// No description provided for @budget_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get budget_total;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @add_schedule.
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
  String get add_schedule;

  /// No description provided for @edit_schedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get edit_schedule;

  /// No description provided for @schedule_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get schedule_title;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start_date;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @on_schedule.
  ///
  /// In en, this message translates to:
  /// **'On Schedule'**
  String get on_schedule;

  /// No description provided for @late.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// No description provided for @solved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get solved;

  /// No description provided for @unsolve.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get unsolve;

  /// No description provided for @no_schedules.
  ///
  /// In en, this message translates to:
  /// **'No schedule items'**
  String get no_schedules;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @add_delay.
  ///
  /// In en, this message translates to:
  /// **'Add Delay'**
  String get add_delay;

  /// No description provided for @delay_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get delay_title;

  /// No description provided for @delay_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get delay_reason;

  /// No description provided for @excusable.
  ///
  /// In en, this message translates to:
  /// **'Excusable'**
  String get excusable;

  /// No description provided for @compensable.
  ///
  /// In en, this message translates to:
  /// **'Compensable'**
  String get compensable;

  /// No description provided for @concurrent.
  ///
  /// In en, this message translates to:
  /// **'Concurrent'**
  String get concurrent;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @additional_info.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additional_info;

  /// No description provided for @finish_delay.
  ///
  /// In en, this message translates to:
  /// **'Finish Delay'**
  String get finish_delay;

  /// No description provided for @no_delays.
  ///
  /// In en, this message translates to:
  /// **'No delays'**
  String get no_delays;

  /// No description provided for @responsibility.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get responsibility;

  /// No description provided for @add_responsibility.
  ///
  /// In en, this message translates to:
  /// **'Add Responsibility'**
  String get add_responsibility;

  /// No description provided for @edit_responsibility.
  ///
  /// In en, this message translates to:
  /// **'Edit Responsibility'**
  String get edit_responsibility;

  /// No description provided for @responsibility_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get responsibility_title;

  /// No description provided for @responsibility_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get responsibility_description;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @solved_state.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get solved_state;

  /// No description provided for @responsible_email.
  ///
  /// In en, this message translates to:
  /// **'Responsible Email'**
  String get responsible_email;

  /// No description provided for @no_responsibilities.
  ///
  /// In en, this message translates to:
  /// **'No responsibilities'**
  String get no_responsibilities;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get add_photo;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get take_photo;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get choose_from_gallery;

  /// No description provided for @photo_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get photo_description;

  /// No description provided for @no_photos.
  ///
  /// In en, this message translates to:
  /// **'No photos'**
  String get no_photos;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @map_address.
  ///
  /// In en, this message translates to:
  /// **'Map Address'**
  String get map_address;

  /// No description provided for @search_address.
  ///
  /// In en, this message translates to:
  /// **'Search address'**
  String get search_address;

  /// No description provided for @address_saved.
  ///
  /// In en, this message translates to:
  /// **'Address saved'**
  String get address_saved;

  /// No description provided for @address_not_found.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get address_not_found;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @confirm_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirm_delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @toast_fill_email.
  ///
  /// In en, this message translates to:
  /// **'Please fill email'**
  String get toast_fill_email;

  /// No description provided for @toast_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get toast_invalid_email;

  /// No description provided for @toast_fill_password.
  ///
  /// In en, this message translates to:
  /// **'Please fill password'**
  String get toast_fill_password;

  /// No description provided for @toast_password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get toast_password_length;

  /// No description provided for @toast_fill_password_again.
  ///
  /// In en, this message translates to:
  /// **'Please repeat password'**
  String get toast_fill_password_again;

  /// No description provided for @toast_passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get toast_passwords_dont_match;

  /// No description provided for @toast_fill_title.
  ///
  /// In en, this message translates to:
  /// **'Please fill title'**
  String get toast_fill_title;

  /// No description provided for @toast_fill_address.
  ///
  /// In en, this message translates to:
  /// **'Please fill address'**
  String get toast_fill_address;

  /// No description provided for @toast_fill_construction_type.
  ///
  /// In en, this message translates to:
  /// **'Please fill construction type'**
  String get toast_fill_construction_type;

  /// No description provided for @toast_fill_description.
  ///
  /// In en, this message translates to:
  /// **'Please fill description'**
  String get toast_fill_description;

  /// No description provided for @toast_fill_deadline.
  ///
  /// In en, this message translates to:
  /// **'Please fill deadline'**
  String get toast_fill_deadline;

  /// No description provided for @toast_fill_value.
  ///
  /// In en, this message translates to:
  /// **'Please fill value'**
  String get toast_fill_value;

  /// No description provided for @toast_value_only_numbers.
  ///
  /// In en, this message translates to:
  /// **'Value must be a number'**
  String get toast_value_only_numbers;

  /// No description provided for @toast_fill_reason.
  ///
  /// In en, this message translates to:
  /// **'Please fill reason'**
  String get toast_fill_reason;

  /// No description provided for @toast_fill_textview.
  ///
  /// In en, this message translates to:
  /// **'Please fill this field'**
  String get toast_fill_textview;

  /// No description provided for @toast_fill_dropdown.
  ///
  /// In en, this message translates to:
  /// **'Please select from dropdown'**
  String get toast_fill_dropdown;

  /// No description provided for @toast_select_responsible.
  ///
  /// In en, this message translates to:
  /// **'Please select responsible'**
  String get toast_select_responsible;

  /// No description provided for @toast_unexpected_error.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get toast_unexpected_error;

  /// No description provided for @toast_user_exists.
  ///
  /// In en, this message translates to:
  /// **'User already exists'**
  String get toast_user_exists;

  /// No description provided for @toast_network_error.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection'**
  String get toast_network_error;

  /// No description provided for @email_verif_send.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get email_verif_send;

  /// No description provided for @email_updated.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get email_updated;

  /// No description provided for @email_already_verified.
  ///
  /// In en, this message translates to:
  /// **'Email already verified'**
  String get email_already_verified;

  /// No description provided for @acc_verified.
  ///
  /// In en, this message translates to:
  /// **'Account verified'**
  String get acc_verified;

  /// No description provided for @stage_preparation_display.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get stage_preparation_display;

  /// No description provided for @stage_in_progress_display.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get stage_in_progress_display;

  /// No description provided for @stage_cancelled_display.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get stage_cancelled_display;

  /// No description provided for @stage_finished_display.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get stage_finished_display;

  /// No description provided for @prep.
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get prep;

  /// No description provided for @exec.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get exec;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @new_stage.
  ///
  /// In en, this message translates to:
  /// **'New Stage'**
  String get new_stage;

  /// No description provided for @contractor.
  ///
  /// In en, this message translates to:
  /// **'Contractor'**
  String get contractor;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @executor.
  ///
  /// In en, this message translates to:
  /// **'Executor'**
  String get executor;

  /// No description provided for @please_login.
  ///
  /// In en, this message translates to:
  /// **'Please log in first'**
  String get please_login;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @calendar_view.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar_view;

  /// No description provided for @check_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get check_updates;

  /// No description provided for @supabase_guide.
  ///
  /// In en, this message translates to:
  /// **'Supabase Setup Guide'**
  String get supabase_guide;

  /// No description provided for @up_to_date.
  ///
  /// In en, this message translates to:
  /// **'You have the latest version'**
  String get up_to_date;

  /// No description provided for @update_available.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get update_available;

  /// No description provided for @current_version.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current_version;

  /// No description provided for @new_version.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_version;

  /// No description provided for @update_later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get update_later;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @open_release.
  ///
  /// In en, this message translates to:
  /// **'Open Release'**
  String get open_release;

  /// No description provided for @download_error.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get download_error;

  /// No description provided for @open_file_error.
  ///
  /// In en, this message translates to:
  /// **'Could not open file'**
  String get open_file_error;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'ConstructManager — a construction project management app. Developed by Dmitry Dronov.'**
  String get about_description;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @github_profile.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github_profile;

  /// No description provided for @video_guide.
  ///
  /// In en, this message translates to:
  /// **'Video Guide'**
  String get video_guide;

  /// No description provided for @video_guide_url.
  ///
  /// In en, this message translates to:
  /// **'https://youtu.be/O78Gtu5xOIY'**
  String get video_guide_url;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
