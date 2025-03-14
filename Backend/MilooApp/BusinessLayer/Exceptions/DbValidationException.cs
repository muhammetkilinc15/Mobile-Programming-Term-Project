﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer.Exceptions
{
    public class DbValidationException : Exception
    {
        public DbValidationException()
        {
        }

        public DbValidationException(string? message) : base(message)
        {
        }

        public DbValidationException(string? message, Exception? innerException) : base(message, innerException)
        {
        }

        protected DbValidationException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
