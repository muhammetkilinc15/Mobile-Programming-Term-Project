using Azure.Core;
using BusinessLayer.Dtos.AuthDtos;
using DataAccessLayer.Abstract;
using EntityLayer.Entites;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Validators.AuthValidators
{
    public class RegisterValidator : AbstractValidator<RegisterUserRequest>
    {
        private readonly IUserRepository _repository;

        public RegisterValidator(IUserRepository repository)
        {
            _repository = repository;

            //RuleFor(x => x.Email).NotEmpty().EmailAddress()
            //    .WithMessage("Email is required and must be a valid email address")
            //    .MaximumLength(50)
            //    .WithMessage("Email must be at most 50 characters long");



            //RuleFor(x => x.Username).NotEmpty().MinimumLength(3)
            //    .WithMessage("Username is required and must be at least 3 characters long")
            //    .MaximumLength(50)
            //    .WithMessage("Username must be at most 50 characters long");




            //RuleFor(x => x.Password).NotEmpty().MinimumLength(8)
            //    .WithMessage("Password is required and must be at least 8 characters long");

            //RuleFor(x => x.Password).MustAsync(async (string password, CancellationToken cancellation) => await ValidatePasswordLength(password))
            //    .WithMessage("Password must be at least 8 characters long");

            //RuleFor(x => x.Password).MustAsync(async (string password, CancellationToken cancellation) => await ValidatePasswordNumber(password))
            //    .WithMessage("Password must contain at least one number");

            //RuleFor(x => x.Password).MustAsync(async (string password, CancellationToken cancellation) => await ValidatePasswordUpperCase(password))
            //    .WithMessage("Password must contain at least one uppercase letter");

            //RuleFor(x => x.Password).MustAsync(async (string password, CancellationToken cancellation) => await ValidatePasswordLowerCase(password))
            //    .WithMessage("Password must contain at least one lowercase letter");

            //RuleFor(x => x.Password).MustAsync(async (string password, CancellationToken cancellation) => await ValidatePasswordHasSpecialCharacter(password))
            //    .WithMessage("Password must contain at least one special character");



            RuleFor(x => x).MustAsync(async (RegisterUserRequest request, CancellationToken cancellation) => await IsUserUnique(request.Email, request.UserName))
                .WithMessage("User already exist");

        }

        private async Task<bool> ValidatePasswordLength(string password)
        {
            return await Task.FromResult(password.Length >= 8);
        }

        private async Task<bool> ValidatePasswordNumber(string password)
        {
            return await Task.FromResult(password.Any(char.IsDigit));
        }

        private async Task<bool> ValidatePasswordUpperCase(string password)
        {
            return await Task.FromResult(password.Any(char.IsUpper));
        }

        private async Task<bool> ValidatePasswordLowerCase(string password)
        {
            return await Task.FromResult(password.Any(char.IsLower));
        }

        private async Task<bool> ValidatePasswordHasSpecialCharacter(string password)
        {
            return await Task.FromResult(password.Any(char.IsSymbol));
        }

        private async Task<bool> IsUserUnique(string email, string username)
        {
            User existingUser = await _repository.GetSingleAsync(x => x.Email == email || x.UserName == username);
            return existingUser is null;
        }
    }
}
