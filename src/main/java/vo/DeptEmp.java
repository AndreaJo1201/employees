package vo;

public class DeptEmp {
	//테이블 컬럼과 일치하는 도메인 타입?
	//단점: 연결된 테이블의 JOIN 결과를 받을 수 없음.
	//public int empNo;
	//public int deptNo;
	
	//그렇기에 emp_no, dept_no를 가지고있는 클래스를 참조하여 JOIN도 처리 가능하게 선언.
	public Department dept;
	public Employee emp;
	public String fromDate;
	public String toDate;
	//단점 : 복잡함.
}
