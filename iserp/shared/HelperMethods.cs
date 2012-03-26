using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Reflection;
using System.Data.SqlClient;

namespace iserp.shared
{
    public class HelperMethods
    {
        public static string GetConnectionStringLive()
        {
            // return connection string
            return ConfigurationManager.ConnectionStrings["erpdbConnectionString"].ConnectionString;
        }
        public static string GetConnectionStringReport()
        {
            // return connection string
            return ConfigurationManager.ConnectionStrings["erpdbConnectionString"].ConnectionString;
        }

        public static string GetPartNo(string str)
        {
            if (!string.IsNullOrEmpty(str))
            {
                string PreValue = @"-";
                if (str.IndexOf(PreValue) > 0)
                    str = str.Substring(0, str.IndexOf(PreValue)).Trim();
            }
            return str;
        }

    }
}