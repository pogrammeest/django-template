from django.urls import path

from rest_framework_simplejwt.views import (
    TokenRefreshView,
    TokenVerifyView,
)

from app.views.user import (
    LoginView,
    RegisterAPIView,
    ProfileView,

)

authentication_urlpatterns = [
    path("reg/", RegisterAPIView.as_view(), name="register"),
    path("login/", LoginView.as_view(), name="token_obtain_pair"),
    path("refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("verify/", TokenVerifyView.as_view(), name="token_obtain_pair"),
]

user_urlpatterns = [
    path("profile/", ProfileView.as_view(), name="profile"),
]

urlpatterns = authentication_urlpatterns + user_urlpatterns
