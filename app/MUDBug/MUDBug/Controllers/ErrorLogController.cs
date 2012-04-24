using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MUDBug.Models;

namespace MUDBug.Controllers
{ 
    public class ErrorLogController : Controller
    {
        private DBStatsEntities db = new DBStatsEntities();

        //
        // GET: /ErrorLog/

        public ViewResult Index()
        {
            return View(db.MUDBugErrorLogs.ToList());
        }

        //
        // GET: /ErrorLog/Details/5

        public ActionResult DailyCheck()
        {
            db.CallDayCheck();
            return RedirectToAction("Index");  

        }


        public ViewResult Details(int id)
        {
            MUDBugErrorLog mudbugerrorlog = db.MUDBugErrorLogs.Find(id);
            return View(mudbugerrorlog);
        }

        //
        // GET: /ErrorLog/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /ErrorLog/Create

        [HttpPost]
        public ActionResult Create(MUDBugErrorLog mudbugerrorlog)
        {
            if (ModelState.IsValid)
            {
                db.MUDBugErrorLogs.Add(mudbugerrorlog);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(mudbugerrorlog);
        }
        
        //
        // GET: /ErrorLog/Edit/5
 
        public ActionResult Edit(int id)
        {
            MUDBugErrorLog mudbugerrorlog = db.MUDBugErrorLogs.Find(id);
            return View(mudbugerrorlog);
        }

        //
        // POST: /ErrorLog/Edit/5

        [HttpPost]
        public ActionResult Edit(MUDBugErrorLog mudbugerrorlog)
        {
            if (ModelState.IsValid)
            {
                db.Entry(mudbugerrorlog).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(mudbugerrorlog);
        }

        //
        // GET: /ErrorLog/Delete/5
 
        public ActionResult Delete(int id)
        {
            MUDBugErrorLog mudbugerrorlog = db.MUDBugErrorLogs.Find(id);
            return View(mudbugerrorlog);
        }

        //
        // POST: /ErrorLog/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            MUDBugErrorLog mudbugerrorlog = db.MUDBugErrorLogs.Find(id);
            db.MUDBugErrorLogs.Remove(mudbugerrorlog);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}