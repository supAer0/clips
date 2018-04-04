;;; DEFFUNCTIONS

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))

;;; QUERY RULES
	  
(defrule determine-device-type
  (not (type-input ?))
  (not (answer ?))
	=>
    (assert (type-input (yes-or-no-p "Это устройство ввода [нет-вывода]  (yes/no)?"))))

(defrule determine-device-keys ""
  (type-input yes)
  (not (determine-device-keys ?))
  (not (answer ?))
  =>
  (assert (determine-device-keys (yes-or-no-p "Оно имеет клавиши (yes/no)?"))))
  
(defrule determine-device-character ""
  (type-input yes)
  (determine-device-keys yes)
  (not (determine-device-character ?))
  (not (answer ?))
  =>
  (assert (determine-device-character (yes-or-no-p "Позволяет вводить текстовые символы (yes/no)?"))))
 
(defrule determine-device-sound ""
  (type-input yes)
  (determine-device-keys no)
  (not (determine-device-sound ?))
  (not (answer ?))
  =>
  (assert (determine-device-sound (yes-or-no-p "Устройство для ввода звука (yes/no)?"))))

(defrule determine-device-graphics ""
  (type-input yes)
  (determine-device-sound yes)
  (not (determine-device-graphics ?))
  (not (answer ?))
  =>
  (assert (determine-device-graphics (yes-or-no-p "Устройство для ввода графической информации (yes/no)?"))))

(defrule determine-device-sound-out ""
  (type-input no)
  (not (determine-device-sound-out ?))
  (not (answer ?))
  =>
  (assert (determine-device-sound-out (yes-or-no-p "Оно осуществляет вывод звуковой информации (yes/no)?"))))

(defrule determine-device-printed-out ""
  (type-input no)
  (determine-device-sound-out no)
  (not (determine-device-printed-out ?))
  (not (answer ?))
  =>
  (assert (determine-device-printed-out (yes-or-no-p "Может выводить информацию на бумагу (yes/no)?"))))



;;; ANSWER RULES
  
 (defrule device-keyboard ""
  (type-input yes)
	(determine-device-character yes)
	(not (answer ?))
	=>
	(assert (answer "клавиатура")))  
  
 (defrule device-sound-speeker ""
  (type-input no)
	(determine-device-sound-out yes)
	(not (answer ?))
	=>
	(assert (answer "колонки")))
	
 (defrule device-mouse ""
  (type-input yes)
	(determine-device-character no)
	(not (answer ?))
	=>
	(assert (answer "мышь")))
	
(defrule device-wheel ""
  (type-input yes)
	(determine-device-keys no)
  (determine-device-sound no)
	(not (answer ?))
	=>
	(assert (answer "руль")))

(defrule device-micro ""
  (type-input yes)
  (determine-device-keys no)
  (determine-device-graphics no)
	(not (answer ?))
	=>
	(assert (answer "микрофон")))

(defrule device-camera ""
  (type-input yes)
  (determine-device-keys no)
  (determine-device-graphics yes)
	(not (answer ?))
	=>
	(assert (answer "камера")))

(defrule device-printer ""
  (type-input no)
  (determine-device-printed-out yes)
	(not (answer ?))
	=>
	(assert (answer "принтер")))

(defrule device-monitor ""
  (type-input no)
  (determine-device-printed-out no)
	(not (answer ?))
	=>
	(assert (answer "монитор")))

;;; STARTUP AND CONCLUSION RULES
	
(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Экспертная система для определиния устройств")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (answer ?item)
  =>
  (printout t crlf crlf)
  (printout t "Ответ:")
  (printout t crlf crlf)
  (format t "Ваше устройство: %s%n%n%n" ?item))