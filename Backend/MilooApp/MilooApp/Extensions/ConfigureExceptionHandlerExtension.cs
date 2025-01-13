using BusinessLayer.Exceptions;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;
using MilooApp.Extensions;
using System.Net;
using System.Net.Mime;
using System.Security;
using System.Security.Authentication;
using System.Text.Json;

namespace NotArkadasimApi.Infsracture.Extensions
{
    public static class ApplicationBuilderExtension
    {
        public static IApplicationBuilder ConfigureExceptionHandling(this IApplicationBuilder app,
            bool includeExceptionDetails = false,
            bool useDefaultHandlingResponse = true,
            Func<HttpContext, Exception, Task>? handleException = null)
        {
            _ = app.UseExceptionHandler(opt =>
            {
                opt.Run(context =>
                {
                    var exceptionObj = context.Features.Get<IExceptionHandlerFeature>();

                    if (!useDefaultHandlingResponse && handleException == null)
                        throw new ArgumentException("handleException cannot be null when useDefaultHandlingResponse is false");

                    if (!useDefaultHandlingResponse && handleException != null)
                        return handleException(context, exceptionObj.Error);

                    return DefaultHandleException(context, exceptionObj.Error, includeExceptionDetails);
                });
            });

            return app;
        }

        private static async Task DefaultHandleException(HttpContext context, Exception exception, bool includeExceptionDetails = true)
        {
            HttpStatusCode status = HttpStatusCode.InternalServerError;
            string message = "An unexpected error occurred.";

            if (exception is UnauthorizedAccessException)
            {
                status = HttpStatusCode.Unauthorized;
                message = "Unauthorized access.";
                await WriteResponse(context, status, message);
                return;
            }
            else if (exception is AuthenticationException)
            {
                status = HttpStatusCode.Unauthorized;
                message = "Authentication failed.";
                await WriteResponse(context, status, message);
                return;
            }
            else if (exception is SecurityException)
            {
                status = HttpStatusCode.Forbidden;
                message = "Forbidden access.";
                await WriteResponse(context, status, message);
                return;
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

        // Write response to the HTTP context
        private static async Task WriteResponse(HttpContext context, HttpStatusCode httpStatus, object responseObject)
        {
            context.Response.ContentType = MediaTypeNames.Application.Json;
            context.Response.StatusCode = (int)httpStatus;
            await context.Response.WriteAsJsonAsync(responseObject);
        }
    }
}
