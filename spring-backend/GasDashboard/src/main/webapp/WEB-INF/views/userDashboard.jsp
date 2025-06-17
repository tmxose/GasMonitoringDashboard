<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대시보드</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript" src="../../resources/js/test.js"></script>
<style>
body {
	margin: 0;
	font-family: sans-serif;
	background-color: #f5f5f5;
}

.dashboard {
	width: 70vw;
	margin: 40px auto;
	padding: 30px;
	background-color: #1e1e2f;
	border-radius: 12px;
	box-shadow: 0px 4px 10px rgba(0, 0, 0, 0, 1);
	box-sizing: border-box;
}

.header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
}

.header h2 {
	color: white;
	margin: 0;
	font-size: 1.8rem;
	margin: 0;
}

.charts-top {
	display: flex;
	gap: 35px;
	margin-bottom: 40px;
	flex-wrap: wrap;
	justify-content: center;
}

.chart-box {
	position: relative;
	width: 45%; /* ✅ 한 줄에 2개 배치 (가로 여백 포함) */
	flex: 1 1 300px;
	aspect-ratio: 4/2.2;
	background-color: #e6e6e6;
	border-radius: 12px;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 0;
	box-sizing: border-box;
}

.chart-box img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 10px;
	box-sizing: border-box;
}

.chart-title {
	position: absolute;
	top: 12px;
	left: 12px;
	background-color: rgba(255, 255, 255, 0.7); /* 배경 흰색 반투명 */
	padding: 6px 12px;
	border-radius: 6px;
	font-weight: bold;
	font-size: 1.1rem;
	color: #333;
	z-index: 2; /* 이미지를 덮도록 */
}

/* 드롭다운 컨트롤 */
.controls {
	margin-bottom: 30px;
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: 20px;
}

.controls label {
	color: white;
	font-weight: 500;
}

.controls select {
	padding: 8px 14px;
	border-radius: 8px;
	border: 1px solid #ccc;
	font-size: 1rem;
}

/* 하단 차트 컨테이너 */
.charts-bottom {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	justify-content: center;
}

.chart-container {
	flex: 1 1 400px;
	min-width: 500px;
	aspect-ratio: 1.5/1;
	background-color: #f0f0f0;
	border-radius: 10px;
	padding: 15px;
	display: flex;
	align-items: center;
	justify-content: center;
	box-sizing: border-box;
	background-color: #f0f0f0;
}

.chart-container img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	border-radius: 10px;
	box-sizing: border-box;
}

/* 버튼 스타일 */
button {
	padding: 8px 18px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 1rem;
	tramsition: background-color 0.3s;
}

button:hover {
	background-color: #0056b3;
}
</style>
</head>
<body>
	<!-- 전체 대시보드 컨테이너 -->
	<div class="dashboard">
		<!-- 상단 헤더  -->
		<div class="header">
			<h2>📊 Dashboard</h2>
			<button>편집 완료</button>
		</div>
		<h2>내</h2>

		<!-- 상단 차트 공간 -->
		<div class="charts-top">
			<div class="chart-box">
				<form method="get" id="cityForm" onsubmit="return false;">
					<label for="city">지역 선택:</label> <select id="city" name="city"
						required>
						<option value="" disabled selected>지역을 선택하세요</option>
						<option value="서울특별시">서울특별시</option>
						<option value="인천광역시">인천광역시</option>
						<option value="경기도">경기도</option>
						<option value="부산광역시">부산광역시</option>
						<option value="대구광역시">대구광역시</option>
						<option value="광주광역시">광주광역시</option>
						<option value="대전광역시">대전광역시</option>
						<option value="울산광역시">울산광역시</option>
						<option value="세종특별자치시">세종특별자치시</option>
						<option value="강원특별자치도">강원특별자치도</option>
						<option value="충청북도">충청북도</option>
						<option value="충청남도">충청남도</option>
						<option value="전북특별자치도">전북특별자치도</option>
						<option value="전라남도">전라남도</option>
						<option value="경상북도">경상북도</option>
						<option value="경상남도">경상남도</option>
						<option value="제주특별자치도">제주특별자치도</option>
					</select> <label for="model">분석 모델 선택:</label> <select id="model"
						name="model" required>
						<option value="" disabled selected>모델을 선택하세요</option>
						<option value="XGBoost">XGBoost</option>
						<option value="Prophet">Prophet</option>
						<option value="LSTM">LSTM</option>
					</select> <label for="period">예측 기간:</label> <select id="period"
						name="period" required>
						<option value="3" selected>3개월</option>
						<option value="6">6개월</option>
						<option value="12">12개월</option>
					</select>
					<button type="button" onclick="fetchPrediction()">조회</button>
				</form>
				<p id="loading" style="display: none;">데이터를 불러오는 중입니다...</p>
				<p id="xgb-result"></p>
				<canvas id="gasChart"></canvas>
			</div>
			<div class="chart-box">
				<c:if test="${not empty visualizations}">
					<div class="chart-title">온도-공급량 관계</div>
					<img src="data:image/png;base64,${visualizations.temp_supply}" />
				</c:if>
			</div>

			<%-- 	<div class="chart-box">
				<c:if test="${not empty visualizations}">
					<div class="chart-title">지역별 패턴</div>
					<img src="data:image/png;base64,${visualizations.regional_pattern}" />
				</c:if>
			</div> --%>
		</div>

		<%-- 	<form method="get" id="cityForm" onsubmit="return false;">
		<label for="city">지역 선택:</label>
		<select id="city" name="city" required>
			<option value="" disabled selected>지역을 선택하세요</option>
			<option value="서울특별시">서울특별시</option>
			<option value="인천광역시">인천광역시</option>
			<option value="경기도">경기도</option>
			<option value="부산광역시">부산광역시</option>
			<option value="대구광역시">대구광역시</option>
			<option value="광주광역시">광주광역시</option>
			<option value="대전광역시">대전광역시</option>
			<option value="울산광역시">울산광역시</option>
			<option value="세종특별자치시">세종특별자치시</option>
			<option value="강원특별자치도">강원특별자치도</option>
			<option value="충청북도">충청북도</option>
			<option value="충청남도">충청남도</option>
			<option value="전북특별자치도">전북특별자치도</option>
			<option value="전라남도">전라남도</option>
			<option value="경상북도">경상북도</option>
			<option value="경상남도">경상남도</option>
			<option value="제주특별자치도">제주특별자치도</option>
		</select>
		<label for="model">분석 모델 선택:</label>
		<select id="model" name="model" required>
			<option value="" disabled selected>모델을 선택하세요</option>
			<option value="XGBoost">XGBoost</option>
			<option value="Prophet">Prophet</option>
			<option value="LSTM">LSTM</option>
		</select>
		<label for="period">예측 기간:</label>
		<select id="period" name="period" required>
			<option value="3" selected>3개월</option>
			<option value="6">6개월</option>
			<option value="12">12개월</option>
		</select>
		<button type="button" onclick="fetchPrediction()">조회</button>
	</form>
	<p id="loading" style="display:none;">데이터를 불러오는 중입니다...</p>
	<p id="xgb-result"></p>
	<canvas id="gasChart"></canvas> --%>
		<!-- 선택 컨트롤 -->
		<div class="controls">
			<label for="city">Select City:</label> <select id="city" name="city">
				<option value="" disabled selected>지역을 선택하세요</option>
				<option value="서울">서울</option>
				<option value="경기도">경기도</option>
				<option value="부산">부산</option>
				<option value="울산">울산</option>
			</select> <label for="model">Select Model:</label> <select id="model"
				name="model">
				<option value="" disabled selected>모델을 선택하세요</option>
				<option value=""></option>
				<option value=""></option>
				<option value=""></option>
			</select>
		</div>

		<!-- 하단 차트 3개 -->
		<div class="charts-bottom">
			<div class="chart-container">
				<img
					src="data:image/png;base64,${visualizations.supply_prediction_timeline_xgboost}" />
			</div>
			<div class="chart-container">
				<img
					src="data:image/png;base64,${visualizations.lstm_prediction_timeline}" />
			</div>
			<div class="chart-container">
				<img src="data:image/png;base64,${visualizations.regional_pattern}" />
			</div>
			<div class="chart-container">
				<img
					src="data:image/png;base64,${visualizations.prophet_prediction_timeline}" />
			</div>
		</div>
	</div>

	<!-- 예제 코드 -->
	<%-- 	<c:if test="${not empty models}">
		<h3>XGBoost</h3>
		<ul>
			<li>MSE: ${models.XGBoost.mse}</li>
			<li>RMSE: ${models.XGBoost.rmse}</li>
			<li>R²: ${models.XGBoost.r2}</li>
		</ul>

		<h3>Prophet</h3>
		<p>${models.Prophet.model}</p>

		<h3>LSTM</h3>
		<p>${models.LSTM.model}</p>
	</c:if>
 --%>

	<h2>시각화 결과</h2>
	<c:if test="${not empty visualizations}">
		<h3>월별 추이</h3>
		<img src="data:image/png;base64,${visualizations.monthly_trend}" />

		<h3>온도-공급량 관계</h3>
		<img src="data:image/png;base64,${visualizations.temp_supply}" />

		<h3>지역별 패턴</h3>
		<img src="data:image/png;base64,${visualizations.regional_pattern}" />

		<h3>예측 비교</h3>
		<img
			src="data:image/png;base64,${visualizations.prediction_comparison}" />
	</c:if>

	<%-- 	<c:if test="${not empty error}">

			src="data:image/png;base64,${visualizations.prediction_comparison}" />
</c:if>
	<c:if test="${not empty error}">
		<p style="color: red;">오류: ${error}</p>
	</c:if> --%>


<script>
	let gasChart = null;
</script>

</body>


</html>