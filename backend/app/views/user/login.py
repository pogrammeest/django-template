from rest_framework import response, status
from rest_framework_simplejwt.views import TokenObtainPairView


from app.models import User
from app.serializers.user import CustomTokenObtainPairSerializer


class LoginView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

    def post(self, request, *args, **kwargs):
        post_token = super().post(request, *args, **kwargs)
        user = User.objects.get(email=request.data["email"])
        if user.confirmed_email:
            return post_token
        return response.Response(
            status=status.HTTP_401_UNAUTHORIZED,
            data={"detail": "Почта не подтверждена"},
        )
