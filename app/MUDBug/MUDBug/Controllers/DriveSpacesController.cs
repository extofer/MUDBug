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
    public class DriveSpacesController : Controller
    {
        private DBStatsEntities db = new DBStatsEntities();

        //
        // GET: /DriveSpaces/

        public ViewResult Index()
        {
            return View(db.MUDBUGDriveSpaces.ToList());
        }

        //
        // GET: /DriveSpaces/Details/5

        public ViewResult Details(int id)
        {
            MUDBUGDriveSpace mudbugdrivespace = db.MUDBUGDriveSpaces.Find(id);
            return View(mudbugdrivespace);
        }

        //
        // GET: /DriveSpaces/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /DriveSpaces/Create

        [HttpPost]
        public ActionResult Create(MUDBUGDriveSpace mudbugdrivespace)
        {
            if (ModelState.IsValid)
            {
                db.MUDBUGDriveSpaces.Add(mudbugdrivespace);
                db.SaveChanges();
                return RedirectToAction("Index");  
            }

            return View(mudbugdrivespace);
        }
        
        //
        // GET: /DriveSpaces/Edit/5
 
        public ActionResult Edit(int id)
        {
            MUDBUGDriveSpace mudbugdrivespace = db.MUDBUGDriveSpaces.Find(id);
            return View(mudbugdrivespace);
        }

        //
        // POST: /DriveSpaces/Edit/5

        [HttpPost]
        public ActionResult Edit(MUDBUGDriveSpace mudbugdrivespace)
        {
            if (ModelState.IsValid)
            {
                db.Entry(mudbugdrivespace).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(mudbugdrivespace);
        }

        //
        // GET: /DriveSpaces/Delete/5
 
        public ActionResult Delete(int id)
        {
            MUDBUGDriveSpace mudbugdrivespace = db.MUDBUGDriveSpaces.Find(id);
            return View(mudbugdrivespace);
        }

        //
        // POST: /DriveSpaces/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {            
            MUDBUGDriveSpace mudbugdrivespace = db.MUDBUGDriveSpaces.Find(id);
            db.MUDBUGDriveSpaces.Remove(mudbugdrivespace);
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