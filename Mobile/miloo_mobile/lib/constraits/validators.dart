import 'package:form_field_validator/form_field_validator.dart';

final emailValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
    PatternValidator(
      r"^[0-9]+@ogr\.[a-zA-Z0-9.-]+\.(edu(\.[a-zA-Z]{2,})?)$",
      errorText: "Please enter your student mail",
    )
  ],
);

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8,
        errorText: 'Password must be at least 8 characters long'),
    MaxLengthValidator(
      20,
      errorText: "",
    )
  ],
);

final usernameValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Username is required'),
    MinLengthValidator(3,
        errorText: 'Username must be at least 3 characters long'),
  ],
);

final firstNameValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'First name is required'),
    MinLengthValidator(3,
        errorText: 'First name must be at least 3 characters long'),
  ],
);

final lastNameValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Last name is required'),
    MinLengthValidator(3,
        errorText: 'Last name must be at least 3 characters long'),
  ],
);

final userNameValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Username is required'),
    MinLengthValidator(3,
        errorText: 'Username must be at least 3 characters long'),
  ],
);
