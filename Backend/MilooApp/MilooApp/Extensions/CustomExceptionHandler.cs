using Microsoft.AspNetCore.Diagnostics;
using MilooApp.Extensions;

namespace NotArkadasimApi.Infsracture.Extensions
{
    using BusinessLayer.Exceptions;
    using Microsoft.AspNetCore.Http;
    using Microsoft.Extensions.Logging;
    using System.Net;
    using System.Security;
    using System.Security.Authentication;

    using System.Threading;
    using System.Threading.Tasks;

    namespace NotArkadasimApi.Infsracture.Extensions
    {
        public class CustomExceptionHandler : IExceptionHandler
        {
            private readonly ILogger<CustomExceptionHandler> _logger;

            public CustomExceptionHandler(ILogger<CustomExceptionHandler> logger)
            {
                _logger = logger;
            }

            private async Task HandleAsync(HttpContext context, Exception exception, bool includeExceptionDetails=false)
            {
                HttpStatusCode status = HttpStatusCode.InternalServerError;
                string message = "An unexpected error occurred.";

                if (exception is UnauthorizedAccessException)
                {
                    includeExceptionDetails = false;
                    status = HttpStatusCode.Unauthorized;
                    message = "Unauthorized access.";
                }
                else if (exception is AuthenticationException)
                {
                    includeExceptionDetails = false;
                    status = HttpStatusCode.Unauthorized;
                    message = "Authentication failed.";
                }
                else if (exception is SecurityException)
                {
                    includeExceptionDetails = false;
                    status = HttpStatusCode.Forbidden;
                    message = "Forbidden access.";
                }
                else if (exception is DbValidationException dbValidationException)
                {
                    status = HttpStatusCode.BadRequest;
                    var validationResponse = new ValidationResponseModel(Errors: [dbValidationException.Message]);
                    await WriteResponse(context, status, validationResponse);
                    return;
                }
                else if (exception is FluentValidation.ValidationException validationException)
                {

                    // Hataları logla
                    _logger.LogError("Validation failed: {Errors}", validationException.Errors);


                    status = HttpStatusCode.BadRequest;
                    var validationResponse = new ValidationResponseModel(validationException.Errors.Select(e => e.ErrorMessage).ToList());
                    await WriteResponse(context, status, validationResponse);
                    return;
                }

                var response = new
                {
                    HttpStatusCode = (int)status,
                    Detail = includeExceptionDetails ? exception.Message : message
                };

                await WriteResponse(context, status, response);
            }

            private static async Task WriteResponse(HttpContext context, HttpStatusCode httpStatus, object responseObject)
            {
                context.Response.ContentType = "application/json";
                context.Response.StatusCode = (int)httpStatus;
                await context.Response.WriteAsJsonAsync(responseObject);
            }

            public async ValueTask<bool> TryHandleAsync(HttpContext httpContext, Exception exception, CancellationToken cancellationToken)
            {
                try
                {
                    await HandleAsync(httpContext, exception, includeExceptionDetails: true);
                    return true;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "An error occurred while handling the exception.");
                    return false;
                }
            }
        }
    }

}
