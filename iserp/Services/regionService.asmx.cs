using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace iserp.Services
{
    /// <summary>
    /// Summary description for regionService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class regionService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }


        [WebMethod]
        public AjaxControlToolkit.CascadingDropDownNameValue[] Getcountry(string knownCategoryValues, string category)
        {
            List<AjaxControlToolkit.CascadingDropDownNameValue> countries = new List<AjaxControlToolkit.CascadingDropDownNameValue>();
            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var ddcountry = from c in db.location_regions
                                where c.flag == 0
                                orderby c.country
                                select new { c.country, c.id_num };
                foreach (var obj in ddcountry)
                {
                    countries.Add(new AjaxControlToolkit.CascadingDropDownNameValue(obj.country.ToString().Trim(), obj.id_num.ToString().Trim()));
                }
            }

            return countries.ToArray();
        }

        [WebMethod]
        public AjaxControlToolkit.CascadingDropDownNameValue[] Getregion(string knownCategoryValues, string category)
        {
            List<AjaxControlToolkit.CascadingDropDownNameValue> regions = new List<AjaxControlToolkit.CascadingDropDownNameValue>();

            var sd = AjaxControlToolkit.CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues);
            string dcountry = sd["country"];

            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var ddregion = from bc in db.location_regions
                               where bc.id_num == Convert.ToInt32(dcountry)
                               select bc;
                dcountry = ddregion.Single().country.ToString();
            }

            using (App_Data.DataClassesERPDataContext db = new App_Data.DataClassesERPDataContext())
            {
                var ddregion = from bc in db.location_regions
                               where bc.country == dcountry && bc.flag == 1
                               orderby bc.region
                               select new { region = bc.region, id_num = bc.id_num };
                foreach (var obj in ddregion)
                {
                    regions.Add(new AjaxControlToolkit.CascadingDropDownNameValue(obj.region.ToString(), obj.id_num.ToString()));
                }
            }
            return regions.ToArray();
        }
    }
}
