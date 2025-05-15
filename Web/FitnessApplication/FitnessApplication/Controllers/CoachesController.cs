using Google.Cloud.Firestore;
using Google.Cloud.Firestore.V1;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using FitnessApplication.Models;
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace FitnessApplication.Controllers
{
    public class CoachesController : Controller
    {
        private readonly ILogger<CoachesController> _logger;
        private readonly FirestoreDb _firestoreDb;

        public CoachesController(ILogger<CoachesController> logger)
        {
            _logger = logger;

            string path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "fitnessapp-3d828-firebase-adminsdk-na9xy-f1631ac5c7.json");

            _firestoreDb = FirestoreDb.Create("fitnessapp-3d828", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(IdentitiyClass model)
        {
            if (model == null)
            {
                ViewData["ErrorMessage"] = "Model null.";
                return View();
            }

            if (string.IsNullOrEmpty(model.email) || string.IsNullOrEmpty(model.password))
            {
                ViewData["ErrorMessage"] = "Lütfen e-posta ve şifreyi girin.";
                return View(model);
            }

            bool isAuthenticated = await AuthenticateAsync(model.email, model.password);

            if (isAuthenticated)
            {
                // Store email in session
                HttpContext.Session.SetString("UserEmail", model.email);
                return RedirectToAction("Index", "Home");
            }
            else
            {

                string errorMessage = await CheckEmailOrPassword(model.email, model.password);
                ViewData["ErrorMessage"] = errorMessage;
                return View(model);
            }
        }

        private async Task<string> CheckEmailOrPassword(string email, string password)
        {
            try
            {
                CollectionReference collection = _firestoreDb.Collection("Coaches");

                DocumentReference docRef = collection.Document(email);
                DocumentSnapshot docSnapshot = await docRef.GetSnapshotAsync();

                if (!docSnapshot.Exists)
                {
                    return "Geçersiz e-posta adresi.";
                }

                string storedPassword = docSnapshot.GetValue<string>("password");

                if (storedPassword == password)
                {
                    return "Başarılı";
                }

                return "Yanlış şifre.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "CheckEmailOrPassword hatası");
                return "Bir hata oluştu. Lütfen daha sonra tekrar deneyin.";
            }
        }

        public class UserModel
        {
            [FirestoreProperty]
            public string Email { get; set; }
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            List<string> documentNames = new List<string>();

            try
            {
                CollectionReference collection = _firestoreDb.Collection("Users");
                QuerySnapshot snapshot = await collection.GetSnapshotAsync();

                foreach (DocumentSnapshot document in snapshot.Documents)
                {
                    documentNames.Add(document.Id);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ListUsers hatası");
                ViewData["ErrorMessage"] = "Kullanıcılar listelenirken bir hata oluştu.";
            }

            return View(documentNames);
        }

        [HttpGet]
        public async Task<IActionResult> UserPrograms(string id)
        {
            List<string> programNames = new List<string>();

            try
            {
                CollectionReference collection = _firestoreDb.Collection("Users").Document(id).Collection("packages").Document("Training").Collection("Programs");
                QuerySnapshot snapshot = await collection.GetSnapshotAsync();

                foreach (DocumentSnapshot document in snapshot.Documents)
                {
                    programNames.Add(document.Id);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "UserPrograms hatası");
                ViewData["ErrorMessage"] = "Programlar listelenirken bir hata oluştu.";
            }

            ViewData["UserId"] = id; // Store userId to use in the view
            return View(programNames);
        }

        [HttpGet]
        public async Task<IActionResult> ProgramDetails(string userId, string programId)
        {
            Dictionary<string, string> programDetails = new Dictionary<string, string>();

            try
            {
                DocumentReference docRef = _firestoreDb.Collection("Users").Document(userId).Collection("packages").Document("Training").Collection("Programs").Document(programId);
                DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

                if (snapshot.Exists)
                {
                    foreach (var field in snapshot.ToDictionary())
                    {
                        programDetails.Add(field.Key, field.Value.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ProgramDetails hatası");
                ViewData["ErrorMessage"] = "Program detayları listelenirken bir hata oluştu.";
            }

            ViewData["UserId"] = userId;
            ViewData["ProgramId"] = programId;
            return View(programDetails);
        }

        [HttpPost]
        public async Task<IActionResult> ProgramDetails(string userId, string programId, Dictionary<string, string> programDetails)
        {
            try
            {
                DocumentReference docRef = _firestoreDb.Collection("Users").Document(userId).Collection("packages").Document("Training").Collection("Programs").Document(programId);

                // Update Firestore document with new values
                await docRef.SetAsync(programDetails);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "ProgramDetails hatası");
                ViewData["ErrorMessage"] = "Program detayları güncellenirken bir hata oluştu.";
            }

            return RedirectToAction("UserPrograms", new { id = userId });
        }

        private async Task<bool> AuthenticateAsync(string email, string password)
        {
            try
            {
                CollectionReference collection = _firestoreDb.Collection("Coaches");

                DocumentReference docRef = collection.Document(email);
                DocumentSnapshot docSnapshot = await docRef.GetSnapshotAsync();

                if (!docSnapshot.Exists)
                {
                    return false;
                }

                string storedPassword = docSnapshot.GetValue<string>("password");

                if (storedPassword == password)
                {
                    return true;
                }

                return false;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "AuthenticateAsync hatası");
                return false;
            }
        }
    }
}
