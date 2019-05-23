using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ContosoInsurance.Models;

namespace ContosoInsurance.Controllers
{
    public class PolicyHoldersController : Controller
    {
        private PolicyConnect db = new PolicyConnect();

        // GET: PolicyHolders
        public ActionResult Index()
        {
            var policyHolders = db.PolicyHolders.Include(p => p.Person).Include(p => p.Policy);
            return View(policyHolders.ToList());
        }

        // GET: PolicyHolders/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PolicyHolder policyHolder = db.PolicyHolders.Find(id);
            if (policyHolder == null)
            {
                return HttpNotFound();
            }
            return View(policyHolder);
        }

        // GET: PolicyHolders/Create
        public ActionResult Create()
        {
            ViewBag.PersonId = new SelectList(db.People, "Id", "FName");
            ViewBag.PolicyId = new SelectList(db.Policies, "Id", "Name");
            return View();
        }

        // POST: PolicyHolders/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "Id,PersonId,Active,StartDate,EndDate,Username,PolicyNumber,PolicyId,FilePath,PolicyAmount,Deductible,OutOfPocketMax,EffectiveDate,ExpirationDate")] PolicyHolder policyHolder)
        {
            if (ModelState.IsValid)
            {
                db.PolicyHolders.Add(policyHolder);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.PersonId = new SelectList(db.People, "Id", "FName", policyHolder.PersonId);
            ViewBag.PolicyId = new SelectList(db.Policies, "Id", "Name", policyHolder.PolicyId);
            return View(policyHolder);
        }

        // GET: PolicyHolders/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PolicyHolder policyHolder = db.PolicyHolders.Find(id);
            if (policyHolder == null)
            {
                return HttpNotFound();
            }
            ViewBag.PersonId = new SelectList(db.People, "Id", "FName", policyHolder.PersonId);
            ViewBag.PolicyId = new SelectList(db.Policies, "Id", "Name", policyHolder.PolicyId);
            return View(policyHolder);
        }

        // POST: PolicyHolders/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "Id,PersonId,Active,StartDate,EndDate,Username,PolicyNumber,PolicyId,FilePath,PolicyAmount,Deductible,OutOfPocketMax,EffectiveDate,ExpirationDate")] PolicyHolder policyHolder)
        {
            if (ModelState.IsValid)
            {
                db.Entry(policyHolder).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.PersonId = new SelectList(db.People, "Id", "FName", policyHolder.PersonId);
            ViewBag.PolicyId = new SelectList(db.Policies, "Id", "Name", policyHolder.PolicyId);
            return View(policyHolder);
        }

        // GET: PolicyHolders/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PolicyHolder policyHolder = db.PolicyHolders.Find(id);
            if (policyHolder == null)
            {
                return HttpNotFound();
            }
            return View(policyHolder);
        }

        // POST: PolicyHolders/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            PolicyHolder policyHolder = db.PolicyHolders.Find(id);
            db.PolicyHolders.Remove(policyHolder);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
