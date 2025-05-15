using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using Google.Cloud.Firestore;
using System.IO;
using Google.Cloud.Firestore.V1;

namespace FitnessApplication.Controllers
{
    public class AccountController : Controller
    {
        private readonly FirestoreDb _firestoreDb;

        public AccountController()
        {
            string path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "fitnessapp-3d828-firebase-adminsdk-na9xy-f1631ac5c7.json");

            _firestoreDb = FirestoreDb.Create("fitnessapp-3d828", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());
        }

        public async Task<IActionResult> Support()
        {
            string userEmail = HttpContext.Session.GetString("UserEmail");

            if (userEmail == null)
            {
                return RedirectToAction("Login", "Account");
            }

            DocumentReference docRef = _firestoreDb.Collection("Coaches").Document(userEmail);
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

            if (snapshot.Exists)
            {
                return View(new User
                {
                    Email = snapshot.GetValue<string>("email"),
                    Name = snapshot.GetValue<string>("name"),
                    Surname = snapshot.GetValue<string>("surname"),
                    Username = snapshot.GetValue<string>("username"),
                    ProfilePictureURL = snapshot.GetValue<string>("profilePictureURL"),
                    UserType = snapshot.GetValue<bool>("userType")
                });
            }
            else
            {
                return View("Error");
            }
        }
        public async Task<IActionResult> Index()
        {
            string userEmail = HttpContext.Session.GetString("UserEmail");

            if (string.IsNullOrEmpty(userEmail))
            {
				return RedirectToAction("Index", "Home");
			}

			DocumentReference docRef = _firestoreDb.Collection("Coaches").Document(userEmail);
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

            if (snapshot.Exists)
            {

                return View(new User
                {
                    Email = snapshot.GetValue<string>("email"),
                    Name = snapshot.GetValue<string>("name"),
                    Surname = snapshot.GetValue<string>("surname"),
                    Username = snapshot.GetValue<string>("username"),
                    ProfilePictureURL = snapshot.GetValue<string>("profilePictureURL"),
                    UserType = snapshot.GetValue<bool>("userType")
                });
            }
            else
            {
                return View("Error");
            }
        }

        public async Task<IActionResult> MyInformation()
        {
            string userEmail = HttpContext.Session.GetString("UserEmail");

            if (userEmail == null)
            {
                return RedirectToAction("Index", "Home");
            }

            DocumentReference docRef = _firestoreDb.Collection("Coaches").Document(userEmail);
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

            if (snapshot.Exists)
            {
                return View(new User
                {
                    Email = snapshot.GetValue<string>("email"),
                    Name = snapshot.GetValue<string>("name"),
                    Surname = snapshot.GetValue<string>("surname"),
                    Username = snapshot.GetValue<string>("username"),
                    ProfilePictureURL = snapshot.GetValue<string>("profilePictureURL"),
                    UserType = snapshot.GetValue<bool>("userType")
                });
            }
            else
            {
                return View("Error");
            }
        }

        public IActionResult EditInformation()
        {
            return View();
        }
    }

    public class User
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public string Surname { get; set; }
        public string Username { get; set; }
        public string ProfilePictureURL { get; set; }
        public bool UserType { get; set; }
    }
}