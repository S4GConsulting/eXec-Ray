@IsTest
public with sharing class CategoryOperationTest {  
    
    @IsTest
    private static void test_orderInsertedAsc(){
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        for(Integer i = 0; i <= 5; i++){
            CategoryOperation categoryOperation  = new CategoryOperation();
            categoryOperation.category = 'Test ' + i;
            categoryOperation.order = i;
            categoryOperations.add(categoryOperation);
        }

        Test.startTest();
            categoryOperations.sort();
        Test.stopTest();

        for(Integer i = 0; i <= 5; i++){
            System.assertEquals(i, categoryOperations[i].order, 'Incorrect order.');            
            System.assertEquals('Test ' + i, categoryOperations[i].category, 'Incorrect order.');
        }
    }

    @IsTest
    private static void test_orderInsertedDesc(){
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        for(Integer i = 0; i <= 5; i++){
            CategoryOperation categoryOperation  = new CategoryOperation();
            categoryOperation.category = 'Test ' + String.valueOf((5 - i));
            categoryOperation.order = (5 - i);
            categoryOperations.add(categoryOperation);
        }

        Test.startTest();
            categoryOperations.sort();
        Test.stopTest();

        for(Integer i = 0; i <= 5; i++){
            System.assertEquals(i, categoryOperations[i].order, 'Incorrect order.');            
            System.assertEquals('Test ' + i, categoryOperations[i].category, 'Incorrect order.');
        }
    }

    @IsTest
    private static void test_orderSameOrder(){
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        CategoryOperation categoryOperationOne  = new CategoryOperation();
        categoryOperationOne.category = 'Test 1';
        categoryOperationOne.order = 1;
        categoryOperations.add(categoryOperationOne);

        CategoryOperation categoryOperationTwo  = new CategoryOperation();
        categoryOperationTwo.category = 'Test 2';
        categoryOperationTwo.order = 1;
        categoryOperations.add(categoryOperationTwo);

        Test.startTest();
            categoryOperations.sort();
        Test.stopTest();

        System.assertEquals(1, categoryOperations[0].order, 'Incorrect order.');            
        System.assertEquals('Test 1', categoryOperations[0].category, 'Incorrect order.');
        System.assertEquals(1, categoryOperations[1].order, 'Incorrect order.');            
        System.assertEquals('Test 2', categoryOperations[1].category, 'Incorrect order.');
    }
}
