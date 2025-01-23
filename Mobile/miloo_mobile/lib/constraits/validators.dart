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
    MaxLengthValidator(20, errorText: 'Password must not exceed 20 characters'),
    PatternValidator(r'(?=.*[a-z])',
        errorText: 'Password must include at least one lowercase letter'),
    PatternValidator(r'(?=.*[A-Z])',
        errorText: 'Password must include at least one uppercase letter'),
    PatternValidator(r'(?=.*\d)',
        errorText: 'Password must include at least one number'),
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

final titleValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Title is required'),
    MinLengthValidator(3,
        errorText: 'Title must be at least 3 characters long'),
    MaxLengthValidator(50, errorText: "Title must not exceed 50 characters"),
  ],
);

final descriptionValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Description is required'),
    MinLengthValidator(10,
        errorText: 'Description must be at least 10 characters long'),
    MaxLengthValidator(500,
        errorText: "Description must not exceed 500 characters"),
  ],
);

final priceValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'Price is required'),
    PatternValidator(r'^[0-9]+(\.[0-9]{1,2})?$',
        errorText: 'Price must be a valid number'),
  ],
);
