from selenium import webdriver
from selenium.common.exceptions import UnexpectedAlertPresentException
from selenium.webdriver.common.alert import Alert

from selenium.webdriver.common.by import By
import time
import os
from dotenv import load_dotenv

load_dotenv()  
driver = webdriver.Chrome()

USERNAME = os.getenv("LOGIN_USERNAME")
PASSWORD = os.getenv("LOGIN_PASSWORD")

# first_name = USERNAME.split("@")[0]
# alert = f"Welcome {first_name}! Checking-in Now"

driver.get("https://people.zoho.in/krisarinfotech/zp#home/myspace/overview-actionlist")

driver.maximize_window()
time.sleep(2)

mail = driver.find_element(By.ID, "login_id")
sign_in = driver.find_element(By.ID, "nextbtn")

mail.send_keys(USERNAME)
sign_in.click()
time.sleep(1)

password = driver.find_element(By.ID, "password")
sign_in = driver.find_element(By.ID, "nextbtn")

password.send_keys(PASSWORD)
sign_in.click()
time.sleep(1)

try:
    check_in_out = driver.find_element(By.ID, "ZPAtt_check_in_out")
    button_text = check_in_out.text.strip().lower()
    first_name = USERNAME.split("@")[0]
    login_alert = f"Welcome {first_name}! Checking-in Now"
    alert = Alert(driver)
    if button_text == "check-out":
        driver.execute_script("alert('You Forgot to Check-Out Yesterday! ')")
        time.sleep(2)
        alert.accept()
        check_in_out.click()
        time.sleep(1)
        attendance_button = driver.find_element(By.CSS_SELECTOR, ".PI_s_attnd.icn")
        attendance_button.click()
        regularisation_button = driver.find_element(By.ID, "ZPAtt_Quick_AddOptionsBtn_list")
        regularisation_button.click()
        time.sleep(2)
        # driver.detach()
        input("Press Enter to exit and close this script (browser will remain open)...")
    else:
        driver.execute_script(f"alert('{login_alert}')")
        time.sleep(1)  # Give time for the alert to appear
        alert.accept()
        check_in_out.click()
        time.sleep(2)
        sign_out_menu = driver.find_element(By.ID, "zpeople_userimage").click()
        time.sleep(1)
        sign_out_button = driver.find_element(By.CSS_SELECTOR, ".PI_close-account.red").click()
        time.sleep(2)
        driver.quit()
        
except UnexpectedAlertPresentException:
    print("Unknown Error Occurred")
Hello 
HI


