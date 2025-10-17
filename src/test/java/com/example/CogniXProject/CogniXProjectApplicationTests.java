package com.example.CogniXProject;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
class CogniXProjectApplicationTests {

	@Test
	void contextLoads() {
		System.out.println("The first test case ran successfully");
	}

	@Test
	void testCase1() {
		System.out.println("The second test case ran successfully");
	}
	@Test
	void testCase12() {
		System.out.println("The Third test case ran successfully");
	}

	@Test
	void testCase5() {
		assertEquals(1,2);
	}

}
