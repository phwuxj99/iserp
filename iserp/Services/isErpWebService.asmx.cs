using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Data.Linq.SqlClient;

namespace iserp
{
    /// <summary>
    /// Summary description for isErpWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class isErpWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public List<string> GetAllPredictions(string keywordStartsWith)
        {
            //StringBuilder sb = new StringBuilder();
            List<string> output = new List<string>();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var query =
                   from ord in db.partnos
                   //where ord.part_no.StartsWith(keywordStartsWith)
                   where SqlMethods.Like(ord.part_no, "%" + keywordStartsWith + "%") & ord.@operator==Global.UserEntityID.ToString()
                   select ord;

                // Execute the query, and change the column values
                // you want to change.
                //foreach (App_Data.partno ord in query)
                foreach (var ord in query)
                {
                    output.Add(ord.part_no.Trim()+"-"+ord.part_name.Trim());
                }

                //return Convert.ToString(sb);
            }
            ////TODO: implement real search here!

            //// dummy implementation
            // IList<string> output = new List<string>();
            // output = sb.ToString().Split('|');
            //output.Add(keywordStartsWith + "1");
            //output.Add(keywordStartsWith + "2");
            //output.Add(keywordStartsWith + "3");
            //output.Add(keywordStartsWith + "4");
            return output;
        }
    }
}
