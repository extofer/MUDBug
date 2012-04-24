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
    public class RestartController : Controller
    {
        private DBStatsEntities db = new DBStatsEntities();

        //
        // GET: /Restart/

        public ViewResult Index()
        {
            return View(db.MUDBugRestarts.ToList());
        }

        //
        // GET: /Restart/Details/5

        public ViewResult Details(int id)
        {
            MUDBugRestart mudbugrestart = db.MUDBugRestarts.Find(id);
            return View(mudbugrestart);
        }

        //
        // GET: /Restart/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Restart/Create

        [HttpPost]
        public ActionResult Create(MUDBugRestart mudbugrestart)
        {
            if (ModelState.IsValid)
            {
                db.MUDBugRestarts.Add(mudbugrestart);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(mudbugrestart);
        }
        
        //
        // GET: /Restart/Edit/5
 
        public ActionResult Edit(int id)
        {
            MUDBugRestart mudbugrestart = db.MUDBugRestarts.Find(id);
            return View(mudbugrestart);
        }

        //
        // POST: /Restart/Edit/5

        [HttpPost]
        public ActionResult Edit(MUDBugRestart mudbugrestart)
        {
            if (ModelState.IsValid)
            {
                db.Entry(mudbugrestart).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(mudbugrestart);
        }

        //
        // GET: /Restart/Delete/5
 
        public ActionResult Delete(int id)
        {
            MUDBugRestart mudbugrestart = db.MUDBugRestarts.Find(id);
            return View(mudbugrestart);
        }

        //
        // POST: /Restart/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            MUDBugRestart mudbugrestart = db.MUDBugRestarts.Find(id);
            db.MUDBugRestarts.Remove(mudbugrestart);
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