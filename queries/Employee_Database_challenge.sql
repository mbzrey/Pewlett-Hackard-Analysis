-- DELIVERABLE 1
-- Query for retiring employees by Title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees AS e
	LEFT JOIN titles AS ti
		ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Use Dictinct with Order by to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title
INTO unique_titles
FROM retirement_titles AS rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

-- Retrieving the number of employees by their most recent job title who are about to retire
SELECT COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC;

-- DELIVERABLE 2
-- Creating a mentorship-eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_elegibility
FROM employees as e
LEFT JOIN dept_emp as de
	ON e.emp_no = de.emp_no
LEFT JOIN titles as ti
	ON e.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- DELIVERABLE 3
-- Creating a table that compares retiring_titles and mentorship_elegibility
SELECT COUNT(me.title),
	me.title
INTO mentoring_titles
FROM mentorship_elegibility AS me
GROUP BY me.title
ORDER BY COUNT(me.title) DESC;

-- Joining retiring_titles and mentoring_titles
SELECT rt.title,
	rt.count AS retiring_count,
	mt.count AS mentoring_count
INTO retiring_mentoring_balance
FROM retiring_titles AS rt
LEFT JOIN mentoring_titles AS mt
	ON rt.title = mt.title
ORDER BY rt.count DESC;

-- Analyzing retiring employees by department
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	d.dept_name	
INTO retirement_departments
FROM employees AS e
	LEFT JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	LEFT JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY emp_no;

-- Retrieving the number of employees by their department who are about to retire
SELECT COUNT(rd.dept_name),
	rd.dept_name
INTO retiring_departments
FROM retirement_departments AS rd
GROUP BY rd.dept_name
ORDER BY COUNT(rd.dept_name) DESC;

-- Creating a mentorship-eligibility table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	d.dept_name	
INTO mentoring_departments
FROM employees AS e
	LEFT JOIN dept_emp AS de
		ON (e.emp_no = de.emp_no)
	LEFT JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY emp_no;

-- Creating a table that compares retiring_departments and mentoring_departments
SELECT COUNT(md.dept_name),
	md.dept_name
INTO mentoring_departments_count
FROM mentoring_departments AS md
GROUP BY md.dept_name
ORDER BY COUNT(md.dept_name) DESC;

-- Joining retiring_departments and mentoring_departments_count
SELECT rd.dept_name,
	rd.count AS retiring_count,
	mdc.count AS mentoring_count
INTO retiring_mentoring_balance_departments
FROM retiring_departments AS rd
LEFT JOIN mentoring_departments_count AS mdc
	ON rd.dept_name = mdc.dept_name
ORDER BY rd.count DESC;