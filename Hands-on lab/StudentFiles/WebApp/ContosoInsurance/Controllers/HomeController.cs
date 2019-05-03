using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ContosoInsurance.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "We take Insurance to the next level!";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Give us a call, we are always home...";

            return View();
        }
    }
}