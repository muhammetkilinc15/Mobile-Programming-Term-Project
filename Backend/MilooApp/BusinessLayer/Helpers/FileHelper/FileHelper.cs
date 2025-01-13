using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace BusinessLayer.Helpers.FileHelper
{
    public class FileHelper : IFileHelper
    {
        private readonly string _uploadsRootFolder;
        private readonly string[] _permittedExtensions = { ".jpeg", ".jpg", ".png", ".jfif" };

        public FileHelper()
        {
            _uploadsRootFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");
        }

        public async Task<string> SaveUserPhotoAsync(IFormFile file, int userId)
        {
            var userFolder = Path.Combine(_uploadsRootFolder, userId.ToString());
            if (!Directory.Exists(userFolder))
            {
                Directory.CreateDirectory(userFolder);
            }
            var userPhotoFolder = Path.Combine(userFolder, "profiles");
            if (!Directory.Exists(userPhotoFolder))
            {
                Directory.CreateDirectory(userPhotoFolder);
            }

            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();

            if (string.IsNullOrEmpty(extension) || !_permittedExtensions.Contains(extension))
            {
                throw new ArgumentException("Invalid image format. Only PNG and JPEG are allowed.");
            }
            var fileName = Guid.NewGuid().ToString() + extension;
            var filePath = Path.Combine(userPhotoFolder, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            // Return the relative path (images/userId/profiles/fileName)
            var relativePath = Path.Combine("images", userId.ToString(), "profiles", fileName);
            return relativePath;
        }


        public async Task<List<string>> SaveUserProductsAsync(List<IFormFile> images, int userId)
        {
            var userFolder = Path.Combine(_uploadsRootFolder, userId.ToString());
            if (!Directory.Exists(userFolder))
            {
                Directory.CreateDirectory(userFolder);
            }
            var productsFolder = Path.Combine(userFolder, "products");
            if (!Directory.Exists(productsFolder))
            {
                Directory.CreateDirectory(productsFolder);
            }

            var savedFilePaths = new ConcurrentBag<string>(); // Thread-safe collection

            // Process each image in parallel
            var tasks = images.Select(async image =>
            {
                var extension = Path.GetExtension(image.FileName).ToLowerInvariant();

                if (string.IsNullOrEmpty(extension) || !_permittedExtensions.Contains(extension))
                {
                    throw new ArgumentException("Invalid image format. Only PNG and JPEG are allowed.");
                }

                // Create a unique filename for each image
                var fileName = Guid.NewGuid().ToString() + extension;

                // Create the full file path
                var filePath = Path.Combine(productsFolder, fileName);

                // Save the image to the file system
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await image.CopyToAsync(stream);
                }

                // Add the relative path (images/userId/products/fileName) to the list
                var relativePath = Path.Combine("images", userId.ToString(), "products", fileName);
                savedFilePaths.Add(relativePath);
            });

            // Wait for all tasks to complete
            await Task.WhenAll(tasks);

            return savedFilePaths.ToList();
        }




    }
}